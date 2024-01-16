# frozen_string_literal: true

RSpec.describe RbsGoose::IO::TypedRuby do
  describe '#to_s' do
    subject { build(:typed_ruby).to_s }

    it 'returns ruby and rbs markdowns' do
      expect(subject).to eq(<<~TYPED_RUBY)
        ```ruby:example_ruby.rb
        ruby_line_1
        ruby_line_2
        ruby_line_3
        ```

        ```rbs:example_rbs.rbs
        rbs_line_1
        rbs_line_2
        rbs_line_3
        ```
      TYPED_RUBY
    end
  end
end
