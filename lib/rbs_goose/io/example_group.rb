# frozen_string_literal: true

module RbsGoose
  module IO
    class ExampleGroup < Array
      class << self
        def load_from(base_path, code_dir: 'lib', sig_dir: 'sig', refined_dir: 'sig.refined')
          Dir.glob('**/*.rb', base: ::File.join(base_path, code_dir)).map do |path|
            Example.from_path(
              ruby_path: ::File.join(code_dir, path),
              rbs_path: to_rbs_path(path, sig_dir),
              refined_rbs_path: to_rbs_path(path, refined_dir),
              base_path: base_path
            )
          end
        end

        private

        def to_rbs_path(path, sig_dir)
          ::File.join(sig_dir, "#{path}s")
        end
      end
    end
  end
end
