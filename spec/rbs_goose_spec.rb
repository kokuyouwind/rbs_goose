# frozen_string_literal: true

RSpec.describe RbsGoose do
  it 'has a version number' do
    expect(RbsGoose::VERSION).not_to be_nil
  end

  describe '.configure' do
    subject do
      described_class.configure
    end

    it 'sets configuration' do
      expect { subject }.to change(described_class, :configuration).from(nil).to(be_a(RbsGoose::Configuration))
    end

    context 'when block is given' do
      subject do
        described_class.configure do |c|
          c.instruction = 'dummy_instruction'
          c.examples = 'dummy_examples'
          c.use_open_ai('dummy_token')
        end
        described_class.configuration
      end

      it 'sets configuration attributes' do
        expect(subject).to have_attributes(
          instruction: 'dummy_instruction',
          examples: 'dummy_examples',
          llm: be_a(Langchain::LLM::OpenAI)
        )
      end
    end
  end

  describe '.reset_configuration', :configure do
    subject do
      described_class.reset_configuration
    end

    it 'resets configuration' do
      expect { subject }.to change(described_class, :configuration).from(be_a(RbsGoose::Configuration)).to(nil)
    end
  end

  describe '.llm', :configure do
    subject { described_class.llm }

    it 'returns llm' do
      expect(subject).to be_a(Langchain::LLM::OpenAI)
    end
  end

  describe '.instruction', :configure do
    subject { described_class.instruction }

    it 'returns instruction' do
      expect(subject).to be_a(String)
    end
  end

  describe '.examples', :configure do
    subject { described_class.examples }

    it 'returns examples' do
      expect(subject).to match(
        [{
          ruby: be_a(RbsGoose::FileIO),
          rbs: be_a(RbsGoose::FileIO),
          refined_rbs: be_a(RbsGoose::FileIO)
        }]
      )
    end
  end
end
