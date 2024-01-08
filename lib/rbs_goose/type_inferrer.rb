# frozen_string_literal: true

require 'openai'
require 'langchain'

module RbsGoose
  class TypeInferrer
    def initialize(llm = nil)
      @llm = llm || ::Langchain::LLM::OpenAI.new(
        api_key: ENV.fetch('OPENAI_ACCESS_TOKEN', nil),
        default_options: {
          completion_model_name: 'gpt-3.5-turbo-0613',
          chat_completion_model_name: 'gpt-3.5-turbo-0613'
        }
      )
    end

    def infer_from_ruby
      llm.complete(prompt: 'Hello!').completion
    end

    private

    attr_reader :llm
  end
end
