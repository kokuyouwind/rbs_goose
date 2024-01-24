# frozen_string_literal: true

module RbsGoose
  module IO
    class File
      MARKDOWN_REGEXP = /\A```(?<type>ruby|rbs):(?<path>.+)\n(?<content>[\s\S]+)```\Z/

      class << self
        def from_markdown(markdown)
          parsed = markdown.match(MARKDOWN_REGEXP)
          raise ArgumentError, "Ruby or RBS Markdown parsing failed.\n#{markdown}" unless parsed

          new(path: parsed[:path], content: parsed[:content])
        end
      end

      def initialize(path:, content: nil, base_path: nil)
        @path = path
        @base_path = base_path
        @content = content&.strip
        load_content if @content.nil?
      end

      def load_content
        @content = ::File.read(absolute_path).strip
      end

      def absolute_path
        base_path ? ::File.join(base_path, path) : path
      end

      def type
        @type ||= case path
                  in /\.rb\z/
                    :ruby
                  in /\.rbs\z/
                    :rbs
                  else
                    raise ArgumentError, "Unknown file type: #{path}"
                  end
      end

      def to_s
        "```#{type}:#{path}\n#{content}\n```\n"
      end

      def content=(content)
        @content = content.strip
      end

      def write
        ::File.write(path, content)
      end

      attr_reader :path, :content, :base_path
    end
  end
end
