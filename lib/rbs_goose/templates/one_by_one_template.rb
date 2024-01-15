# frozen_string_literal: true

require 'langchain'

module RbsGoose
  module Templates
    class OneByOneTemplate
      def initialize(instruction:, examples:)
        @template = Langchain::Prompt::FewShotPromptTemplate.new(
          prefix: instruction,
          suffix: "#{input_template_string}\n",
          example_prompt: example_prompt,
          examples: examples,
          input_variables: %w[typed_ruby]
        )
      end

      def format(typed_ruby)
        template.format(typed_ruby: typed_ruby)
      end

      def parse_result(result)
        [IO::File.from_markdown(result)]
      end

      private

      attr_reader :template

      def example_prompt
        Langchain::Prompt::PromptTemplate.new(
          template: "#{input_template_string}\n{refined_rbs}",
          input_variables: %w[typed_ruby refined_rbs]
        )
      end

      def input_template_string
        "========Input========\n{typed_ruby}\n\n========Output========"
      end
    end
  end
end
