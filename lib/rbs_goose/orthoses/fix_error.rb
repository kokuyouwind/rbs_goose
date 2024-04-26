# frozen_string_literal: true

require 'orthoses/outputable'

module RbsGoose
  module Orthoses
    # Call RbsGoose::TypeInferrer to fix steep type errors.
    #   use TbsGoose::Orthoses::FixError, code_dir: 'lib', sig_dir: 'sig' do |config|
    #     config.use_open_ai('open_ai_access_token')
    #   end
    class FixError
      def initialize(loader, code_dir: 'lib', sig_dir: 'sig', &)
        @loader = loader
        @code_dir = code_dir
        @sig_dir = sig_dir
        RbsGoose.configure(&) if block_given?
      end

      def call
        @loader.call.tap do
          RbsGoose.fix_error(code_dir: @code_dir, sig_dir: @sig_dir)
        end
      end
    end
  end
end
