# frozen_string_literal: true

module RbsGoose
  module IO
    class TypedRuby
      class << self
        def from_path(ruby_path:, rbs_path:, base_path:)
          new(
            ruby: File.new(path: ruby_path, base_path: base_path),
            rbs: File.new(path: rbs_path, base_path: base_path)
          )
        end
      end

      def initialize(ruby:, rbs:)
        raise ArgumentError, 'ruby must have ".rb" extension' unless ruby.type == :ruby
        raise ArgumentError, 'rbs must have ".rbs" extension' unless rbs.type == :rbs

        @ruby = ruby
        @rbs = rbs
      end

      def to_s
        "#{ruby}\n#{rbs}"
      end

      attr_reader :ruby, :rbs
    end
  end
end
