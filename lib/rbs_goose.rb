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

    attr_reader :configuration

    def_delegators :configuration, :llm, :instruction, :example_groups
  end
end
