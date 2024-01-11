# frozen_string_literal: true

require_relative 'rbs_goose/configuration'
require_relative 'rbs_goose/file_io'
require_relative 'rbs_goose/type_inferrer'
require_relative 'rbs_goose/version'

module RbsGoose
  class Error < StandardError; end

  class << self
    def configure(&block)
      @configuration = Configuration.new(&block)
    end

    attr_reader :configuration
  end
end
