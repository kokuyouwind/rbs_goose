# frozen_string_literal: true

require 'langchain'

module RbsGoose
  module Templates
    class FixErrorTemplate < Base
      private

      def input_variables
        %w[typed_ruby_list error_messages]
      end

      def input_template_string
        <<~TEMPLATE.strip
          ========Input========
          {typed_ruby_list}

          ========Errors========
          {error_messages}


          ========Output========
        TEMPLATE
      end

      def format_args(args)
        {
          typed_ruby_list: args[:typed_ruby_list].join("\n"),
          error_messages: args[:error_messages]
        }
      end

      def transform_example_group(example_group)
        {
          typed_ruby_list: example_group.map(&:typed_ruby).join("\n"),
          error_messages: example_group.error_messages,
          refined_rbs_list: example_group.map(&:refined_rbs).join("\n")
        }
      end
    end
  end
end
