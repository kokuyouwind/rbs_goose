# frozen_string_literal: true

module RbsGoose
  module IO
    class ExampleGroup < Array
      class << self
        def load_from(base_path, code_dir: 'lib', sig_dir: 'sig', refined_dir: 'refined')
          new.tap do |group|
            Dir.glob('**/*.rb', base: ::File.join(base_path, code_dir)).each do |path|
              group << Example.from_path(
                ruby_path: ::File.join(code_dir, path),
                rbs_path: to_rbs_path(path, sig_dir),
                refined_rbs_dir: refined_dir,
                base_path: base_path
              )
            end
          end
        end

        def default_examples
          example_dir = ::File.join(__dir__, '../examples')
          @default_examples ||= Dir.glob('*', base: example_dir).to_h do |dir|
            [dir.to_sym, load_from(::File.join(example_dir, dir))]
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
