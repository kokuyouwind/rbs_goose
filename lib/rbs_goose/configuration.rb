# frozen_string_literal: true

require 'langchain'

require 'forwardable'

module RbsGoose
  class Configuration
    extend Forwardable

    LLMConfig = Struct.new(:client, :mode, keyword_init: true)

    TemplateConfig = Struct.new(:instruction, :example_groups, :template_class, keyword_init: true) do
      def build_template
        template_class.new(instruction:, example_groups:)
      end
    end

    def initialize(&)
      self.infer_template = default_infer_template
      self.fix_error_template = default_fix_error_template
      instance_eval(&) if block_given?
    end

    attr_accessor :llm, :infer_template, :fix_error_template

    def use_open_ai( # rubocop:disable Metrics/MethodLength
      open_ai_access_token, model_name: 'gpt-3.5-turbo-1106', mode: :chat,
      llm_options: {}, default_options: {}
    )
      @llm = LLMConfig.new(
        client: ::Langchain::LLM::OpenAI.new(
          api_key: open_ai_access_token,
          llm_options: { request_timeout: 600 }.merge(llm_options),
          default_options: {
            completion_model_name: model_name,
            chat_completion_model_name: model_name
          }.merge(default_options)
        ),
        mode:
      )
    end

    def use_anthropic(access_token, model_name: 'claude-3-haiku-20240307', mode: :chat, default_options: {}) # rubocop:disable Metrics/MethodLength
      @llm = LLMConfig.new(
        client: ::Langchain::LLM::Anthropic.new(
          api_key: access_token,
          default_options: {
            completion_model_name: model_name,
            chat_completion_model_name: model_name,
            max_tokens_to_sample: 4096
          }.merge(default_options)
        ),
        mode:
      )
    end

    def use_ollama(url: 'http://localhost:11434', model_name: 'codegemma', mode: :complete, default_options: {}) # rubocop:disable Metrics/MethodLength
      @llm = LLMConfig.new(
        client: ::Langchain::LLM::Ollama.new(
          url:,
          default_options: {
            temperature: 0.0,
            completion_model_name: model_name,
            chat_completion_model_name: model_name
          }.merge(default_options)
        ),
        mode:
      )
    end

    def_delegator :llm, :client, :llm_client
    def_delegator :llm, :mode, :llm_mode
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

    def default_fix_error_template
      TemplateConfig.new(
        instruction: default_fix_error_instruction,
        example_groups: default_fix_error_example_groups,
        template_class: Templates::FixErrorTemplate
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

    def default_fix_error_instruction
      <<~INSTRUCTION
        You are a highly skilled programmer.
        Based on the following Ruby code, the RBS code that is a type definition, and the type checking error messages for them, modify the RBS code and output it.
        All RBS files should be output, regardless of whether they have been modified or not.
      INSTRUCTION
    end

    def default_fix_error_example_groups
      [RbsGoose::IO::ExampleGroup.default_examples[:fix_errors]]
    end
  end
end
