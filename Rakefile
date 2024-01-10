# frozen_string_literal: true

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
