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

namespace :sig do # rubocop:disable Metrics/BlockLength
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

    Dir.glob('lib/**/*.rb').each do |ruby_path|
      puts "target ruby: #{ruby_path}"
      rbs_path = ruby_path.gsub(%r{^lib/}, 'sig/').gsub(/\.rb$/, '.rbs')
      puts "target rbs: #{rbs_path}"

      typed_ruby = RbsGoose::IO::TypedRuby.new(
        ruby: RbsGoose::IO::File.new(path: ruby_path),
        rbs: RbsGoose::IO::File.new(path: rbs_path)
      )

      RbsGoose::TypeInferrer.new.infer(typed_ruby).each do |refined_rbs|
        puts "write refined rbs to #{refined_rbs.path}\n"
        refined_rbs.write
        puts "done.\n\n"
      end
    rescue StandardError => e
      puts "Error has occurred. Skip #{ruby_path}.\n#{e}"
    end
  end
end
