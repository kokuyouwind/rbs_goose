# frozen_string_literal: true

require 'openai'
require 'langchain'

module RbsGoose
  class Configuration
    def initialize(&block)
      self.instruction = default_instruction
      self.examples = default_examples
      instance_eval(&block) if block_given?
    end

    attr_accessor :llm, :instruction, :examples

    def use_open_ai(open_ai_access_token, default_options: {})
      @llm = ::Langchain::LLM::OpenAI.new(
        api_key: open_ai_access_token,
        default_options: {
          completion_model_name: 'gpt-3.5-turbo-0613',
          chat_completion_model_name: 'gpt-3.5-turbo-0613'
        }.merge(default_options)
      )
    end

    private

    def default_instruction
      'Act as Ruby type inferrer. When ruby source codes and RBS type signatures are given, refine RBS type signatures. Use class names, variable names, etc., to infer type.' # rubocop:disable Layout/LineLength
    end

    def default_examples
      [RbsGoose::IO::Example.new(
        typed_ruby: company_repository_typed,
        refined_rbs: company_repository_refined_rbs
      )]
    end

    def company_repository_typed
      RbsGoose::IO::TypedRuby.new(
        ruby: company_repository_code,
        rbs: company_repository_rbs
      )
    end

    def company_repository_code
      RbsGoose::IO::File.new(path: 'company_repository.rb', content: <<~RUBY)
        class CompanyRepository
          def find
            Company.find_by(id: params[:id])
          end
        end
      RUBY
    end

    def company_repository_rbs
      RbsGoose::IO::File.new(path: 'company_repository.rbs', content: <<~RBS)
        class CompanyRepository
          def find: (untyped id) -> untyped
        end
      RBS
    end

    def company_repository_refined_rbs
      RbsGoose::IO::File.new(path: 'company_repository.rbs', content: <<~RBS)
        class CompanyRepository
          def find: (Integer id) -> Company
        end
      RBS
    end
  end
end
