# frozen_string_literal: true

module RbsGoose
  module IO
    class TargetGroup < Array
      class << self
        def load_from(base_path, code_dir: 'lib', sig_dir: 'sig')
          new.tap do |group|
            Dir.glob('**/*.rb', base: ::File.join(base_path, code_dir)).each do |path|
              group << TypedRuby.from_path(
                ruby_path: ::File.join(code_dir, path),
                rbs_path: ::File.join(sig_dir, "#{path}s"),
                base_path: base_path
              )
            end
          end
        end
      end
    end
  end
end
