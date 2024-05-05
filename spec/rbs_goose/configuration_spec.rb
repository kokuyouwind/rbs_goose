# frozen_string_literal: true

RSpec.describe RbsGoose::Configuration do
  describe '#initialize' do
    subject { described_class.new }

    it 'sets default infer instruction' do
      expect(subject.infer_template.instruction).to start_with('Act as Ruby type inferrer')
    end

    it 'sets default infer example groups' do
      expect(subject.infer_template.example_groups).to contain_exactly(be_a(RbsGoose::IO::ExampleGroup))
    end

    context 'when block is given' do
      subject do
        described_class.new do |c|
          c.infer_template.instruction = 'dummy_instruction'
          c.infer_template.example_groups = []
        end
      end

      it 'sets infer instruction' do
        expect(subject.infer_template.instruction).to eq('dummy_instruction')
      end

      it 'sets infer examples' do
        expect(subject.infer_template.example_groups).to eq([])
      end
    end
  end

  describe '#use_open_ai' do
    it 'sets OpenAI llm' do
      allow(Langchain::LLM::OpenAI).to receive(:new).and_call_original
      described_class.new do |c|
        c.use_open_ai('dummy_token', model_name: 'dummy_model', default_options: { temperature: 0.8 })
      end
      expect(Langchain::LLM::OpenAI).to have_received(:new).with(
        api_key: 'dummy_token',
        default_options: {
          completion_model_name: 'dummy_model',
          chat_completion_model_name: 'dummy_model',
          temperature: 0.8
        },
        llm_options: { request_timeout: 600 }
      )
    end
  end

  describe '#use_anthropic' do
    it 'sets Anthropic llm' do
      allow(Langchain::LLM::Anthropic).to receive(:new).and_call_original
      described_class.new do |c|
        c.use_anthropic('dummy_token', model_name: 'dummy_model', default_options: { temperature: 0.8 })
      end
      expect(Langchain::LLM::Anthropic).to have_received(:new).with(
        api_key: 'dummy_token',
        default_options: {
          completion_model_name: 'dummy_model',
          chat_completion_model_name: 'dummy_model',
          max_tokens_to_sample: 4096,
          temperature: 0.8
        }
      )
    end
  end
end
