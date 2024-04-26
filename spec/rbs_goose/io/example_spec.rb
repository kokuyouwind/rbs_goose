# frozen_string_literal: true

RSpec.describe RbsGoose::IO::Example do
  describe '.from_path' do
    subject do
      described_class.from_path(
        ruby_path: 'lib/test.rb',
        rbs_path: 'sig/test.rbs',
        refined_rbs_dir: 'refined',
        base_path: fixture_path('examples/test')
      )
    end

    it 'load example' do
      expect(subject).to be_a(described_class)
      expect(subject.typed_ruby.ruby).to have_attributes(
        path: 'lib/test.rb',
        content: 'def test; end'
      )
      expect(subject.typed_ruby.rbs).to have_attributes(
        path: 'sig/test.rbs',
        content: 'def test: untyped'
      )
      expect(subject.refined_rbs).to have_attributes(
        path: 'sig/test.rbs',
        content: 'def test: string'
      )
    end
  end

  describe 'to_h' do
    subject { described_class.new(typed_ruby:, refined_rbs:).to_h }

    let(:typed_ruby) { build(:typed_ruby) }
    let(:refined_rbs) { build(:file, :rbs) }

    it 'returns hash' do
      expect(subject).to eq(typed_ruby:, refined_rbs:)
    end
  end
end
