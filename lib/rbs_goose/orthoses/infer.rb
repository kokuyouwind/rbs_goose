# frozen_string_literal: true

module RbsGoose
  module Orthoses
    # Call RbsGoose::TypeInferrer to infer RBS type signatures.
    #   use TbsGoose::Orthoses::Infer, code_dir: 'lib', sig_dir: 'sig' do |config|
    #     config.use_open_ai('open_ai_access_token')
    #   end
    class Infer
      def initialize(_loader, code_dir: 'lib', sig_dir: 'sig', &)
        @code_dir = code_dir
        @sig_dir = sig_dir
        RbsGoose.configure(&)
      end

      def call
        RbsGoose.run(code_dir: @code_dir, sig_dir: @sig_dir)
      end
    end
  end
end
