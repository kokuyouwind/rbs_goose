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
          c.example_groups = 'dummy_examples'
          c.use_open_ai('dummy_token')
        end
        described_class.configuration
      end

      it 'sets configuration attributes' do
        expect(subject).to have_attributes(
          instruction: 'dummy_instruction',
          example_groups: 'dummy_examples',
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

  describe '.run', :configure do
    subject { described_class.run(base_path: base_path) }

    let(:base_path) { fixture_path('examples/user_factory') }
    let(:expected_signatures) { RbsGoose::IO::ExampleGroup.load_from(base_path).to_refined_rbs_list }

    it 'rewrites signatures' do
      VCR.use_cassette('openai/infer_user_factory') do
        allow(File).to receive(:write)

        expect { subject }.to output(/Code Directory: lib, Signature Directory: sig/).to_stdout
        expected_signatures.each do |expected|
          expect(File).to have_received(:write).with(expected.path, expected.content)
        end
      end
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

  describe '.example_groups', :configure do
    subject { described_class.example_groups }

    it 'returns example groups' do
      expect(subject).to contain_exactly(be_a(RbsGoose::IO::ExampleGroup))
    end
  end
end
