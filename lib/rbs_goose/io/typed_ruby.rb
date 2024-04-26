# frozen_string_literal: true

module RbsGoose
  module IO
    class TypedRuby
      class << self
        def from_path(ruby_path:, rbs_path:, base_path:)
          ruby = File.new(path: ruby_path, base_path:)
          rbs = begin
            File.new(path: rbs_path, base_path:)
          rescue StandardError
            nil
          end
          new(ruby:, rbs:)
        end
      end

      def initialize(ruby:, rbs:)
        raise ArgumentError, 'ruby must have ".rb" extension' unless ruby.type == :ruby
        raise ArgumentError, 'rbs must have ".rbs" extension' if !rbs.nil? && rbs.type != :rbs

        @ruby = ruby
        @rbs = rbs
      end

      def to_s
        rbs.nil? ? ruby.to_s : "#{ruby}\n#{rbs}"
      end

      attr_reader :ruby, :rbs
    end
  end
end
