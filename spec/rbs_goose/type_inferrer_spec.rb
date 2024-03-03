# frozen_string_literal: true

RSpec.describe RbsGoose::TypeInferrer, :configure do
  let(:example_group) do
    RbsGoose::IO::ExampleGroup.load_from(fixture_path('examples/user_factory'))
  end
  let(:target_group) { example_group.to_target_group }
  let(:refined_rbs_list) { example_group.to_refined_rbs_list }

  describe '#infer' do
    subject { described_class.new.infer(target_group) }

    context 'with OpenAI API' do
      before do
        RbsGoose.configure do |c|
          c.use_open_ai(ENV.fetch('OPENAI_ACCESS_TOKEN'))
        end
      end

      it 'returns refined rbs' do
        VCR.use_cassette('openai/infer_user_factory') do
          expect(subject).to eq(refined_rbs_list)
        end
      end
    end

    context 'with Ollama' do
      before do
        RbsGoose.configure do |c|
          c.llm = Langchain::LLM::Ollama.new(url: ENV.fetch('OLLAMA_URL', nil),
                                             default_options: {
                                               completion_model_name: 'codellama', temperature: 0
                                             })
        end
      end

      it 'returns refined rbs' do
        VCR.use_cassette('ollama/infer_user_factory') do
          expect(subject).to eq(refined_rbs_list)
        end
      end
    end
  end
end
