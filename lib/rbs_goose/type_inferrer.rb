# frozen_string_literal: true

require 'steep'
require 'steep/cli'

require_relative 'templates'

module RbsGoose
  class TypeInferrer
    def infer(target_group)
      call_llm(RbsGoose.infer_template, { typed_ruby_list: target_group })
    end

    def fix_error(target_group)
      error_messages = steep_check
      call_llm(RbsGoose.fix_error_template, { typed_ruby_list: target_group, error_messages: })
    end

    private

    def call_llm(template, format_args)
      result =
        case RbsGoose.llm_mode.to_sym
        when :complete
          call_llm_complete(format_args, template)
        when :chat
          call_llm_chat(format_args, template)
        else
          raise "Invalid LLM mode: #{RbsGoose.llm_mode}"
        end
      template.parse_result(result)
    end

    def call_llm_complete(format_args, template)
      prompt = template.format(**format_args)
      llm_debug(prompt) do
        RbsGoose.llm.complete(prompt:).completion
      end
    end

    def call_llm_chat(format_args, template)
      messages = [
        { role: 'system', content: template.format_system_prompt },
        { role: 'user', content: template.format_user_prompt(**format_args) }
      ]
      llm_debug(messages) do
        RbsGoose.llm.chat(messages:).completion
      end
    end

    def llm_debug(prompt)
      return yield if ENV['DEBUG'].nil?

      puts "!!!!!!!! Prompt !!!!!!!!\n\n#{prompt}\n\n"
      result = yield
      puts "!!!!!!!! Result !!!!!!!!\n\n#{result}\n\n"
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
