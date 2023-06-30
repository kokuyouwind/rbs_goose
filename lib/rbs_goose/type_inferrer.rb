# frozen_string_literal: true

require 'openai'

module RbsGoose
  class TypeInferrer
    def initialize(llm_client = nil)
      @llm_client = llm_client || OpenAI::Client.new(access_token: ENV.fetch('OPENAI_ACCESS_TOKEN'))
    end

    def infer_from_ruby
      response = llm_client.chat(
        parameters: {
          model: 'gpt-3.5-turbo',
          messages: [{ role: 'user', content: 'Hello!' }],
          temperature: 0
        }
      )
      response.dig('choices', 0, 'message', 'content')
    end

    private

    attr_reader :llm_client
  end
end
