# frozen_string_literal: true

module RbsGoose
  module IO
    class Example
      class << self
        def from_path(ruby_path:, rbs_path:, refined_rbs_dir:, base_path:)
          Example.new(
            typed_ruby: TypedRuby.from_path(ruby_path:, rbs_path:, base_path:),
            refined_rbs: File.new(path: rbs_path, base_path: ::File.join(base_path, refined_rbs_dir))
          )
        end
      end

      def initialize(typed_ruby:, refined_rbs:)
        @typed_ruby = typed_ruby
        @refined_rbs = refined_rbs
      end

      def to_h
        { typed_ruby:, refined_rbs: }
      end

      attr_reader :typed_ruby, :refined_rbs
    end
  end
end
