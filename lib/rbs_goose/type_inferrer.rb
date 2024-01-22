# frozen_string_literal: true

require_relative 'templates'

module RbsGoose
  class TypeInferrer
    def infer(typed_ruby_list)
      template = RbsGoose.configuration.template
      typed_ruby_list.flat_map do |typed_ruby|
        result = RbsGoose.llm.complete(prompt: template.format(typed_ruby)).completion
        template.parse_result(result)
      end
    end
  end
end
