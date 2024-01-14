# frozen_string_literal: true

require_relative 'templates'

module RbsGoose
  class TypeInferrer
    def infer(typed_ruby)
      prompt = Templates::OneByOneTemplate
               .new(instruction: RbsGoose.instruction, examples: RbsGoose.examples)
               .format(typed_ruby)
      RbsGoose.llm.complete(prompt: prompt).completion
    end
  end
end
