# frozen_string_literal: true

require_relative 'templates'

module RbsGoose
  class TypeInferrer
    def infer(target_group)
      template = RbsGoose.infer_template
      result = RbsGoose.llm.complete(prompt: template.format(target_group)).completion
      template.parse_result(result)
    end
  end
end
