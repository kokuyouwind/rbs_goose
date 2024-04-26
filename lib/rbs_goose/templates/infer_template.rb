# frozen_string_literal: true

require 'langchain'

module RbsGoose
  module Templates
    class InferTemplate < Base
      private

      def input_variables
        %w[typed_ruby_list]
      end

      def input_template_string
        "========Input========\n{typed_ruby_list}\n\n========Output========"
      end

      def format_args(args)
        { typed_ruby_list: args[:typed_ruby_list].join("\n") }
      end

      def transform_example_group(example_group)
        {
          typed_ruby_list: example_group.map(&:typed_ruby).join("\n"),
          refined_rbs_list: example_group.map(&:refined_rbs).join("\n")
        }
      end
    end
  end
end
