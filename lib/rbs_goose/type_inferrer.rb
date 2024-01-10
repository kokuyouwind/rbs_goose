# frozen_string_literal: true

require 'openai'
require 'langchain'
require_relative 'file_io'

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

    def infer(ruby, rbs)
      prompt = few_shot_template.format(ruby: ruby, rbs: rbs)
      llm.complete(prompt: prompt).completion
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
      Langchain::Prompt::FewShotPromptTemplate.new(
        prefix: 'Act as Ruby type inferrer. When ruby source codes and RBS type signatures are given, refine RBS type signatures. Use class names, variable names, etc., to infer type.', # rubocop:disable Layout/LineLength
        suffix: input_template_string,
        example_prompt: example_prompt,
        examples: [
          {
            ruby: company_repository_code.to_markdown,
            rbs: company_repository_rbs.to_markdown,
            refined_rbs: company_repository_refined_rbs.to_markdown
          }
        ],
        input_variables: %w[ruby rbs]
      )
    end

    def company_repository_code
      RBSGoose::FileIO.new('company_repository.rb', content: <<~RUBY)
        class CompanyRepository
          def find
            Company.find_by(id: params[:id])
          end
        end
      RUBY
    end

    def company_repository_rbs
      RBSGoose::FileIO.new('company_repository.rbs', content: <<~RBS)
        class CompanyRepository
          def find: (untyped id) -> untyped
        end
      RBS
    end

    def company_repository_refined_rbs
      RBSGoose::FileIO.new('company_repository.rbs', content: <<~RBS)
        class CompanyRepository
          def find: (Integer id) -> Company
        end
      RBS
    end
  end
end
