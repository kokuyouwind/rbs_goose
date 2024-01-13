# frozen_string_literal: true

require 'langchain'

module RbsGoose
  module Templates
    class OneByOneTemplate
      def initialize(instruction:, examples:) # rubocop:disable Metrics/MethodLength
        @template = Langchain::Prompt::FewShotPromptTemplate.new(
          prefix: instruction,
          suffix: input_template_string,
          example_prompt: example_prompt,
          examples: examples.map do |example|
            {
              ruby: example[:ruby].to_markdown,
              rbs: example[:rbs].to_markdown,
              refined_rbs: example[:refined_rbs].to_markdown
            }
          end,
          input_variables: %w[ruby rbs]
        )
      end

      def format(ruby:, rbs:)
        template.format(ruby: ruby, rbs: rbs)
      end

      private

      attr_reader :template

      def example_prompt
        Langchain::Prompt::PromptTemplate.new(
          template: "#{input_template_string}\n{refined_rbs}",
          input_variables: %w[ruby rbs refined_rbs]
        )
      end

      def input_template_string
        "========Input========\n{ruby}\n{rbs}\n\n========Output========"
      end
    end
  end
end
