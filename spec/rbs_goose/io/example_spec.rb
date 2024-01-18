# frozen_string_literal: true

RSpec.describe RbsGoose::IO::Example do
  describe 'to_h' do
    subject { described_class.new(typed_ruby: typed_ruby, refined_rbs: refined_rbs).to_h }

    let(:typed_ruby) { build(:typed_ruby) }
    let(:refined_rbs) { build(:file, :rbs) }

    it 'returns hash' do
      expect(subject).to eq(typed_ruby: typed_ruby, refined_rbs: refined_rbs)
    end
  end
end
