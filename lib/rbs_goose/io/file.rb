# frozen_string_literal: true

module RbsGoose
  module IO
    class File
      MARKDOWN_REGEXP = /\A```(?<type>ruby|rbs):(?<path>.+)\n(?<content>[\s\S]+)```\Z/

      class << self
        def from_markdown(markdown)
          parsed = markdown.match(MARKDOWN_REGEXP)
          raise ArgumentError, "Ruby or RBS Markdown parsing failed.\n#{markdown}" unless parsed

          new(parsed[:path], content: parsed[:content])
        end
      end

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
