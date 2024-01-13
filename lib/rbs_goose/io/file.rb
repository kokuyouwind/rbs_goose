# frozen_string_literal: true

module RbsGoose
  module IO
    class File
      def initialize(path, content: nil)
        @path = path
        @type = case path
                in /\.rb\z/
                  :ruby
                in /\.rbs\z/
                  :rbs
                else
                  raise ArgumentError, "Unknown file type: #{path}"
                end
        @content = content.strip
      end

      def to_s
        "```#{type}:#{path}\n#{content}\n```\n"
      end

      def content=(content)
        @content = content.strip
      end

      attr_reader :path, :type, :content
    end
  end
end
