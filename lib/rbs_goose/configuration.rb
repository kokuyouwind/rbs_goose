# frozen_string_literal: true

require 'openai'
require 'langchain'

module RbsGoose
  class Configuration
    def initialize(&block)
      self.instruction = default_instruction
      self.example_groups = default_example_groups
      self.template_class = default_template_class
      instance_eval(&block) if block_given?
    end

    attr_accessor :llm, :instruction, :example_groups, :template_class

    def use_open_ai(open_ai_access_token, default_options: {})
      @llm = ::Langchain::LLM::OpenAI.new(
        api_key: open_ai_access_token,
        default_options: {
          completion_model_name: 'gpt-3.5-turbo-0613',
          chat_completion_model_name: 'gpt-3.5-turbo-0613'
        }.merge(default_options)
      )
    end

    def template
      @template ||= template_class.new(instruction: instruction, example_groups: example_groups)
    end

    private

    def default_template_class
      Templates::OneByOneTemplate
    end

    def default_instruction
      'Act as Ruby type inferrer. When ruby source codes and RBS type signatures are given, refine RBS type signatures. Use class names, variable names, etc., to infer type.' # rubocop:disable Layout/LineLength
    end

    def default_example_groups
      [RbsGoose::IO::ExampleGroup.default_examples[:company_repository]]
    end
  end
end
