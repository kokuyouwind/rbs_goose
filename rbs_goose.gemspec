# frozen_string_literal: true

require_relative 'lib/rbs_goose/version'

Gem::Specification.new do |spec|
  spec.name = 'rbs_goose'
  spec.version = RbsGoose::VERSION
  spec.authors = ['kokuyouwind']
  spec.email = ['kokuyouwind@gmail.com']

  spec.summary = 'RBS type inferrer with LLM'
  spec.description = 'RBS type inferrer with LLM'
  spec.homepage = 'https://github.com/kokuyouwind/rbs_goose'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.3.0'

  # spec.metadata["allowed_push_host"] = 'https://example.com'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/kokuyouwind/rbs_goose'
  spec.metadata['changelog_uri'] = 'https://github.com/kokuyouwind/rbs_goose/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '>= 2.9.0', '< 3.0.0'
  spec.add_dependency 'langchainrb', '>= 0.12.0', '< 1.0.0'
  spec.add_dependency 'steep', '>= 1.6.0', '< 2.0.0'

  spec.add_runtime_dependency 'anthropic', '>= 0.2.0', '< 1.0.0'
  spec.add_runtime_dependency 'orthoses', '>= 1.13.0', '< 2.0.0'
  spec.add_runtime_dependency 'ruby-openai', '>= 6.1.0', '< 8.0.0'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
