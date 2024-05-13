# frozen_string_literal: true

require 'dotenv/load'

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'

RuboCop::RakeTask.new

task default: %i[spec rubocop]

desc 'Run specs'
task :spec do
  Rake::Task['spec'].invoke
end

desc 'Run specs and record VCR cassettes'
task :'spec:record' do
  ENV['RECORD'] = 'all'
  Rake::Task['spec'].invoke
end

namespace :sig do
  desc 'refine RBS files in sig directory'
  task :refine do
    require 'orthoses'
    require_relative 'lib/rbs_goose'

    Orthoses::Builder.new do
      # use RbsGoose::Orthoses::FixError
      use RbsGoose::Orthoses::Infer do |config|
        # config.use_open_ai(ENV.fetch('OPENAI_ACCESS_TOKEN'), model_name: 'gpt-3.5-turbo-0125')
        # config.use_open_ai(ENV.fetch('OPENAI_ACCESS_TOKEN'), model_name: 'gpt-4-turbo-2024-04-09')
        config.use_anthropic(ENV.fetch('ANTHROPIC_API_KEY', nil), model_name: 'claude-3-haiku-20240307')
        # config.use_anthropic(ENV.fetch('ANTHROPIC_API_KEY', nil), model_name: 'claude-3-sonnet-20240229')
        # config.use_anthropic(ENV.fetch('ANTHROPIC_API_KEY', nil), model_name: 'claude-3-opus-20240229')
        # config.use_ollama(model_name: 'codegemma')
      end
      use Orthoses::CreateFileByName,
          to: 'sig',
          rmtree: true
      # use Orthoses::PP
      use Orthoses::Filter do |name, _|
        name.start_with?('RbsGoose')
      end
      use Orthoses::Mixin
      use Orthoses::RBSPrototypeRB, paths: Dir.glob('lib/**/*.rb')
      run -> {}
    end.call
  end

  desc 'fix RBS'
  task :fix do
    require 'orthoses'
    require_relative 'lib/rbs_goose'

    Orthoses::Builder.new do
      use RbsGoose::Orthoses::FixError do |config|
        config.use_anthropic(ENV.fetch('ANTHROPIC_API_KEY', nil), model_name: 'claude-3-opus-20240229')
        # config.use_open_ai(ENV.fetch('OPENAI_ACCESS_TOKEN'), model_name: 'gpt-4-turbo-2024-04-09')
      end
      run -> {}
    end.call
  end
end

namespace :readme do
  desc 'translate japanese README to english README'
  task :translate do
    require 'langchain'
    require 'openai'

    readme_ja = File.read('README-ja.md')
    puts '======== Japanese README ========'
    puts readme_ja

    llm = Langchain::LLM::OpenAI.new(
      api_key: ENV.fetch('OPENAI_ACCESS_TOKEN'),
      default_options: {
        completion_model_name: 'gpt-3.5-turbo-1106',
        chat_completion_model_name: 'gpt-3.5-turbo-1106'
      }
    )

    readme_en = llm.complete(prompt: <<~PROMPT).completion
      Translate the following markdown document into English, keeping the markdown formatting.

      ======== INPUT ========
      #{readme_ja}

      ======== OUTPUT ========
    PROMPT
    puts '======== Translated English README ========'
    puts readme_en
    File.write('README.md', readme_en)
  end
end
