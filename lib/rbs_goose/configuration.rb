# frozen_string_literal: true

require 'openai'
require 'langchain'

require 'forwardable'

module RbsGoose
  class Configuration
    extend Forwardable

    TemplateConfig = Struct.new(:instruction, :example_groups, :template_class, keyword_init: true) do
      def build_template
        template_class.new(instruction:, example_groups:)
      end
    end

    def initialize(&)
      self.infer_template = default_infer_template
      instance_eval(&) if block_given?
    end

    attr_accessor :llm, :infer_template

    def use_open_ai(open_ai_access_token, default_options: {})
      @llm = ::Langchain::LLM::OpenAI.new(
        api_key: open_ai_access_token,
        default_options: {
          completion_model_name: 'gpt-3.5-turbo-1106',
          chat_completion_model_name: 'gpt-3.5-turbo-1106'
        }.merge(default_options)
      )
    end

    def_delegator :infer_template, :instruction, :infer_instruction
    def_delegator :infer_template, :example_groups, :infer_example_groups

    private

    def default_infer_template
      TemplateConfig.new(
        instruction: default_infer_instruction,
        example_groups: default_infer_example_groups,
        template_class: Templates::InferTemplate
      )
    end

    def default_infer_instruction
      <<~INSTRUCTION
        Act as Ruby type inferrer.
        When ruby source codes and RBS type signatures are given, refine each RBS type signatures. Each file should be split in markdown code format.
        Use class names, variable names, etc., to infer type.
      INSTRUCTION
    end

    def default_infer_example_groups
      [RbsGoose::IO::ExampleGroup.default_examples[:rbs_samples]]
    end
  end
end
