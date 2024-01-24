# frozen_string_literal: true

module RbsGoose
  module IO
    class TypedRuby
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
