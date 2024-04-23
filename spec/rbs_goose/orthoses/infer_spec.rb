# frozen_string_literal: true

RSpec.describe RbsGoose::Orthoses::Infer do
  describe '#initialize' do
    subject { described_class.new(-> {}) }

    it 'sets default code_dir' do
      expect(subject.instance_variable_get(:@code_dir)).to eq('lib')
    end

    it 'sets default sig_dir' do
      expect(subject.instance_variable_get(:@sig_dir)).to eq('sig')
    end

    context 'when block is given' do
      subject do
        described_class.new(-> {}) do |config|
          config.use_open_ai('open_ai_access_token')
        end
      end

      it 'sets OpenAI llm' do
        subject
        expect(RbsGoose.configuration.llm).to be_a(Langchain::LLM::OpenAI)
      end
    end
  end

  describe '#call' do
    subject { described_class.new(-> {}) }

    it 'calls RbsGoose.run' do
      allow(RbsGoose).to receive(:run)
      subject.call
      expect(RbsGoose).to have_received(:run).with(code_dir: 'lib', sig_dir: 'sig')
    end
  end
end
