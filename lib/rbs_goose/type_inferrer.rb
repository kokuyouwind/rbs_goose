# frozen_string_literal: true

require 'openai'
require 'langchain'
require_relative 'file_io'

module RbsGoose
  class TypeInferrer
    def infer(ruby, rbs)
      prompt = few_shot_template.format(ruby: ruby, rbs: rbs)
      RbsGoose.llm.complete(prompt: prompt).completion
    end

    private

    attr_reader :llm

    def input_template_string
      "========Input========\n{ruby}\n{rbs}\n\n========Output========"
    end

    def example_prompt
      Langchain::Prompt::PromptTemplate.new(
        template: "#{input_template_string}\n{refined_rbs}",
        input_variables: %w[ruby rbs refined_rbs]
      )
    end

    def few_shot_template # rubocop:disable Metrics/MethodLength
      examples = RbsGoose.examples.map do |example|
        {
          ruby: example[:ruby].to_markdown,
          rbs: example[:rbs].to_markdown,
          refined_rbs: example[:refined_rbs].to_markdown
        }
      end
      Langchain::Prompt::FewShotPromptTemplate.new(
        prefix: RbsGoose.instruction,
        suffix: input_template_string,
        example_prompt: example_prompt,
        examples: examples,
        input_variables: %w[ruby rbs]
      )
    end
  end
end
