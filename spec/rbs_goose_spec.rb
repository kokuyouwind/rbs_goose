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
end
