# frozen_string_literal: true

require 'langchain'

module RbsGoose
  module Templates
    class FixErrorTemplate
      def initialize(instruction:, example_groups:)
        @instruction = instruction
        @example_groups = example_groups
      end

      def format(typed_ruby_list, error_messages)
        Langchain::Prompt::FewShotPromptTemplate.new(
          prefix: instruction,
          suffix: "#{input_template_string}\n",
          example_prompt:,
          examples: example_groups.map { transform_example_group(_1) },
          input_variables: %w[typed_ruby_list error_messages]
        ).format(
          typed_ruby_list: typed_ruby_list.join("\n"),
          error_messages:
        )
      end

      def parse_result(result)
        result.scan(/```.+?```/m).map { IO::File.from_markdown(_1) }
      end

      private

      attr_reader :instruction, :example_groups

      def example_prompt
        Langchain::Prompt::PromptTemplate.new(
          template: "#{input_template_string}\n{refined_rbs_list}",
          input_variables: %w[typed_ruby_list error_messages refined_rbs_list]
        )
      end

      def input_template_string
        <<~TEMPLATE.strip
          ========Input========
          {typed_ruby_list}

          ========Errors========
          {error_messages}


          ========Output========
        TEMPLATE
      end

      def transform_example_group(example_group)
        {
          typed_ruby_list: example_group.map(&:typed_ruby).join("\n"),
          error_messages: example_group.error_messages,
          refined_rbs_list: example_group.map(&:refined_rbs).join("\n")
        }
      end
    end
  end
end
