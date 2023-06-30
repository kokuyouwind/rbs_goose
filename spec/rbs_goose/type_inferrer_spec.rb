# frozen_string_literal: true

RSpec.describe RbsGoose::TypeInferrer do
  describe '#infer_from_ruby' do
    subject { described_class.new.infer_from_ruby }

    it 'returns hello message' do
      VCR.use_cassette('openai') do
        expect(subject).to eq('Hello! How can I assist you today?')
      end
    end
  end
end
