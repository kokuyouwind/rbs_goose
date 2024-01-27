# frozen_string_literal: true

RSpec.describe RbsGoose::IO::TypedRuby do
  describe '.from_path' do
    subject do
      described_class.from_path(
        ruby_path: 'lib/test.rb',
        rbs_path: 'sig/test.rbs',
        base_path: fixture_path('examples/test')
      )
    end

    it 'load typed ruby' do
      expect(subject).to be_a(described_class)
      expect(subject.ruby).to have_attributes(
        path: 'lib/test.rb',
        content: 'def test; end'
      )
      expect(subject.rbs).to have_attributes(
        path: 'sig/test.rbs',
        content: 'def test: untyped'
      )
    end
  end

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
