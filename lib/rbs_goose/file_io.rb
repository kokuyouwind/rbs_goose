# frozen_string_literal: true

module RBSGoose
  class FileIO
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

    def to_markdown
      "```#{type}:#{path}\n#{content}\n```"
    end

    def content=(content)
      @content = content.strip
    end

    attr_reader :path, :type, :content
  end
end
