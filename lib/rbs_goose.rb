# frozen_string_literal: true

require_relative 'rbs_goose/configuration'
require_relative 'rbs_goose/io'
require_relative 'rbs_goose/type_inferrer'
require_relative 'rbs_goose/version'

require 'forwardable'

module RbsGoose
  class Error < StandardError; end

  class << self
    extend Forwardable

    def configure(&block)
      @configuration = Configuration.new(&block)
    end

    def reset_configuration
      @configuration = nil
    end

    def run(code_dir: 'lib', sig_dir: 'sig', base_path: ::Dir.pwd)
      puts "Run RbsGoose.(Code Directory: #{code_dir}, Signature Directory: #{sig_dir})"
      target_group = RbsGoose::IO::TargetGroup.load_from(base_path, code_dir: code_dir, sig_dir: sig_dir)
      RbsGoose::TypeInferrer.new.infer(target_group).each do |refined_rbs|
        puts "write refined rbs to #{refined_rbs.path}\n"
        refined_rbs.write
        puts "done.\n\n"
      end
    end

    attr_reader :configuration

    def_delegators :configuration, :llm, :instruction, :example_groups
  end
end
