# frozen_string_literal: true

require 'langchain'

module RbsGoose
  module Templates
    class Base
      def initialize(instruction:, example_groups:)
        @instruction = instruction
        @example_groups = example_groups
      end

      def format(**args)
        Langchain::Prompt::FewShotPromptTemplate.new(
          prefix:,
          suffix:,
          example_prompt:,
          examples: example_groups.map { transform_example_group(_1) },
          input_variables:
        ).format(**format_args(args))
      end

      def parse_result(result)
        result.scan(/```.+?```/m).map { IO::File.from_markdown(_1) }
      end

      private

      def input_template_string
        raise NotImplementedError
      end

      def input_variables
        raise NotImplementedError
      end

      def transform_example_group(example_group)
        raise NotImplementedError
      end

      def format_args(args)
        raise NotImplementedError
      end

      def prefix
        instruction
      end

      def suffix
        "#{input_template_string}\n"
      end

      def example_prompt
        Langchain::Prompt::PromptTemplate.new(
          template: "#{input_template_string}\n{refined_rbs_list}",
          input_variables: input_variables + ['refined_rbs_list']
        )
      end

      attr_reader :instruction, :example_groups

    end
  end
end
