# frozen_string_literal: true

RSpec.describe RbsGoose::Configuration do
  describe '#initialize' do
    subject { described_class.new }

    it 'sets default instruction' do
      expect(subject.instruction).to start_with('Act as Ruby type inferrer')
    end

    it 'sets default example groups' do
      expect(subject.example_groups).to contain_exactly(be_a(RbsGoose::IO::ExampleGroup))
    end

    context 'when block is given' do
      subject do
        described_class.new do |c|
          c.instruction = 'dummy_instruction'
          c.example_groups = []
        end
      end

      it 'sets instruction' do
        expect(subject.instruction).to eq('dummy_instruction')
      end

      it 'sets examples' do
        expect(subject.example_groups).to eq([])
      end
    end
  end

  describe '#use_open_ai' do
    it 'sets OpenAI llm' do
      allow(Langchain::LLM::OpenAI).to receive(:new).and_call_original
      described_class.new do |c|
        c.use_open_ai('dummy_token', default_options: { completion_model_name: 'dummy_model' })
      end
      expect(Langchain::LLM::OpenAI).to have_received(:new).with(
        api_key: 'dummy_token',
        default_options: {
          completion_model_name: 'dummy_model',
          chat_completion_model_name: 'gpt-3.5-turbo-0613'
        }
      )
    end
  end
end
