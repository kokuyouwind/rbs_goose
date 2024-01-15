# frozen_string_literal: true

require_relative 'templates'

module RbsGoose
  class TypeInferrer
    def infer(typed_ruby)
      template = Templates::OneByOneTemplate
                 .new(instruction: RbsGoose.instruction, examples: RbsGoose.examples)
      result = RbsGoose.llm.complete(prompt: template.format(typed_ruby)).completion
      template.parse_result(result)
    end
  end
end
