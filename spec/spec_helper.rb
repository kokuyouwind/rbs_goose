# frozen_string_literal: true

require 'simplecov'
require 'simplecov-cobertura'

SimpleCov.start do
  coverage_dir 'tmp/coverage'
  enable_coverage :branch
  add_filter %r{^/spec/}
  formatter formatter SimpleCov::Formatter::MultiFormatter.new(
    [
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCov::Formatter::CoberturaFormatter
    ]
  )
end

require 'rbs_goose'
require 'openai'
require 'anthropic'

require 'dotenv/load'
require 'factory_bot'
require 'vcr'

RSPEC_ROOT = File.dirname __FILE__
def fixture_path(path)
  File.join(RSPEC_ROOT, 'fixtures', path)
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.filter_sensitive_data('<openai_access_token>') { ENV.fetch('OPENAI_ACCESS_TOKEN') }
  config.filter_sensitive_data('<anthropic_api_key>') { ENV.fetch('ANTHROPIC_API_KEY') }
  config.default_cassette_options = {
    match_requests_on: %i[method uri body],
    record: ENV.fetch('RECORD', :once).to_sym
  }
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # FactoryBot
  config.include FactoryBot::Syntax::Methods
  config.before(:suite) do
    FactoryBot.define do
      initialize_with { new(**attributes) }
    end
    FactoryBot.find_definitions
  end

  config.before(:example, :configure) do
    RbsGoose.configure do |c|
      c.use_open_ai(ENV.fetch('OPENAI_ACCESS_TOKEN'))
    end
  end

  config.after do
    RbsGoose.reset_configuration
  end
end
