# frozen_string_literal: true

require_relative 'templates'

module RbsGoose
  class TypeInferrer
    def infer(typed_ruby_list)
      template = RbsGoose.configuration.template
      result = RbsGoose.llm.complete(prompt: template.format(typed_ruby_list)).completion
      template.parse_result(result)
    end
  end
end
