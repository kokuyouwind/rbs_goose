# frozen_string_literal: true

require 'steep'
require 'steep/cli'

require_relative 'templates'

module RbsGoose
  class TypeInferrer
    def infer(target_group)
      template = RbsGoose.infer_template
      result = complete(template.format(target_group))
      template.parse_result(result)
    end

    def fix_error(target_group)
      error_messages = steep_check
      template = RbsGoose.fix_error_template
      prompt = template.format(target_group, error_messages)
      result = complete(prompt)
      template.parse_result(result)
    end

    private

    def complete(prompt)
      is_debug = !ENV['DEBUG'].nil?
      puts "Prompt: #{prompt}" if is_debug
      result = RbsGoose.llm.complete(prompt:).completion
      puts "Result: #{result}" if is_debug
      result
    end

    def steep_check
      stdin, stdout, stderr = io_stubs
      disable_rainbow do
        steep_cli = Steep::CLI.new(stdout:, stdin:, stderr:, argv: [])
        steep_cli.process_check
      end
      stdout.string
    end

    def io_stubs
      [StringIO.new(''), StringIO.new(+'', 'w+'), StringIO.new(+'', 'w+')]
    end

    def disable_rainbow
      rainbow_enabled = Rainbow.enabled
      Rainbow.enabled = false
      yield
      Rainbow.enabled = rainbow_enabled
    end
  end
end
