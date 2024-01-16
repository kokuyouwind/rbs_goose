# frozen_string_literal: true

RSpec.describe RbsGoose::IO::File do
  describe '.from_markdown' do
    subject { described_class.from_markdown(markdown) }

    context 'when ruby markdown' do
      let(:markdown) do
        <<~MARKDOWN
          ```ruby:path/to/ruby.rb
          ruby_line_1
          ruby_line_2
          ruby_line_3
          ```
        MARKDOWN
      end

      it 'returns ruby file' do
        expect(subject).to have_attributes(
          path: 'path/to/ruby.rb',
          type: :ruby,
          content: <<~RUBY.strip
            ruby_line_1
            ruby_line_2
            ruby_line_3
          RUBY
        )
      end
    end

    context 'when rbs markdown' do
      let(:markdown) do
        <<~MARKDOWN
          ```rbs:path/to/rbs.rbs
          rbs_line_1
          rbs_line_2
          rbs_line_3
          ```
        MARKDOWN
      end

      it 'returns rbs file' do
        expect(subject).to have_attributes(
          path: 'path/to/rbs.rbs',
          type: :rbs,
          content: <<~RBS.strip
            rbs_line_1
            rbs_line_2
            rbs_line_3
          RBS
        )
      end
    end
  end

  describe '#type' do
    subject { file.type }

    context 'when ruby file' do
      let(:file) { build(:file, :ruby) }

      it 'returns ruby' do
        expect(subject).to eq(:ruby)
      end
    end

    context 'when rbs file' do
      let(:file) { build(:file, :rbs) }

      it 'returns rbs' do
        expect(subject).to eq(:rbs)
      end
    end
  end

  describe '#to_s' do
    subject { file.to_s }

    context 'when ruby file' do
      let(:file) { build(:file, :ruby, :with_multi_line_content) }

      it 'returns ruby markdown' do
        expect(subject).to eq(<<~MARKDOWN)
          ```ruby:example_ruby.rb
          line_1
          line_2
          line_3
          ```
        MARKDOWN
      end
    end

    context 'when rbs file' do
      let(:file) { build(:file, :rbs, :with_multi_line_content) }

      it 'returns rbs markdown' do
        expect(subject).to eq(<<~MARKDOWN)
          ```rbs:example_rbs.rbs
          line_1
          line_2
          line_3
          ```
        MARKDOWN
      end
    end
  end

  describe '#content=' do
    subject do
      file.content = 'updated_content'
      file.content
    end

    let(:file) { build(:file) }

    it 'sets content' do
      expect(subject).to eq('updated_content')
    end
  end
end
