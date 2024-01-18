# frozen_string_literal: true

module RbsGoose
  module IO
    class Example
      def initialize(typed_ruby:, refined_rbs:)
        @typed_ruby = typed_ruby
        @refined_rbs = refined_rbs
      end

      def to_h
        { typed_ruby: typed_ruby, refined_rbs: refined_rbs }
      end

      private

      attr_reader :typed_ruby, :refined_rbs
    end
  end
end
