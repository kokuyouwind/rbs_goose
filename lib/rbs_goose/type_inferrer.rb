# frozen_string_literal: true

require_relative 'templates'

module RbsGoose
  class TypeInferrer
    def infer(ruby, rbs)
      prompt = Templates::OneByOneTemplate
               .new(instruction: RbsGoose.instruction, examples: RbsGoose.examples)
               .format(ruby: ruby, rbs: rbs)
      RbsGoose.llm.complete(prompt: prompt).completion
    end
  end
end
