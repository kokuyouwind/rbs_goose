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
  desc 'build RBS prototypes to sig directory'
  task :prototype do
    require 'orthoses'
    require_relative 'lib/rbs_goose'

    Orthoses::Builder.new do
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

  desc 'refine RBS files in sig directory'
  task :refine do
    require_relative 'lib/rbs_goose'

    RbsGoose.configure do |c|
      c.use_open_ai(ENV.fetch('OPENAI_ACCESS_TOKEN'))
    end
    RbsGoose.run
  end
end
