# frozen_string_literal: true

require_relative 'rbs_goose/configuration'
require_relative 'rbs_goose/io'
require_relative 'rbs_goose/orthoses'
require_relative 'rbs_goose/type_inferrer'
require_relative 'rbs_goose/version'

require 'forwardable'

module RbsGoose
  class Error < StandardError; end

  class << self
    extend Forwardable

    def configure(&)
      @configuration = Configuration.new(&)
    end

    def reset_configuration
      @configuration = nil
    end

    def run(code_dir: 'lib', sig_dir: 'sig', base_path: ::Dir.pwd)
      puts "Run RbsGoose.(Code Directory: #{code_dir}, Signature Directory: #{sig_dir})"
      target_group = RbsGoose::IO::TargetGroup.load_from(base_path, code_dir:, sig_dir:)
      RbsGoose::TypeInferrer.new.infer(target_group).each do |refined_rbs|
        puts "write refined rbs to #{refined_rbs.path}\n"
        refined_rbs.write
        puts "done.\n\n"
      end
    end

    def infer_template
      configuration.infer_template.build_template
    end

    attr_reader :configuration

    def_delegators :configuration, :llm, :infer_instruction, :infer_example_groups
  end
end
