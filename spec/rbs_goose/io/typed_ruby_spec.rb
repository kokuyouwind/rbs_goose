# frozen_string_literal: true

RSpec.describe RbsGoose::IO::TypedRuby do
  let(:ruby_file) do
    RbsGoose::IO::File.new(
      'ruby_file.rb',
      content: <<~RUBY)
        ruby_line_1
        ruby_line_2
        ruby_line_3
      RUBY
  end

  let(:rbs_file) do
    RbsGoose::IO::File.new(
      'rbs_file.rbs',
      content: <<~RBS)
        rbs_line_1
        rbs_line_2
        rbs_line_3
      RBS
  end

  describe '#to_s' do
    subject { described_class.new(ruby_file, rbs_file).to_s }

    it 'returns ruby and rbs markdowns' do
      expect(subject).to eq(<<~TYPED_RUBY)
        ```ruby:ruby_file.rb
        ruby_line_1
        ruby_line_2
        ruby_line_3
        ```

        ```rbs:rbs_file.rbs
        rbs_line_1
        rbs_line_2
        rbs_line_3
        ```
      TYPED_RUBY
    end
  end
end
