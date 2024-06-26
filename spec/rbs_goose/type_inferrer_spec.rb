# frozen_string_literal: true

RSpec.describe RbsGoose::TypeInferrer do
  let(:type_inferrer) { described_class.new }
  let(:target_group) { example_group.to_target_group }
  let(:refined_rbs_list) { example_group.to_refined_rbs_list }

  describe '#infer' do
    subject { type_inferrer.infer(target_group) }

    let(:example_group) do
      RbsGoose::IO::ExampleGroup.load_from(fixture_path('examples/user_factory'))
    end

    context 'with openai llm', :configure do
      context 'with mode=complete' do
        before do
          RbsGoose.configuration.llm.mode = :complete
        end

        it 'returns refined rbs' do
          VCR.use_cassette('openai_complete/infer_user_factory') do
            expect(subject).to eq(refined_rbs_list)
          end
        end
      end

      context 'with mode=chat' do
        before do
          RbsGoose.configuration.llm.mode = :chat
        end

        it 'returns refined rbs' do
          VCR.use_cassette('openai_chat/infer_user_factory') do
            expect(subject).to eq(refined_rbs_list)
          end
        end
      end
    end

    context 'with anthropic' do
      before do
        RbsGoose.configure do |c|
          c.use_anthropic(ENV.fetch('ANTHROPIC_API_KEY'))
        end
      end

      it 'returns refined rbs' do
        VCR.use_cassette('anthropic_chat/infer_user_factory') do
          expect(subject).to eq(refined_rbs_list)
        end
      end
    end

    context 'with ollama(codegemma)' do
      context 'with mode=complete' do
        before do
          RbsGoose.configure do |c|
            c.use_ollama(model_name: 'codegemma', mode: :complete)
          end
        end

        it 'returns refined rbs' do
          VCR.use_cassette('ollama_codegemma_complete/infer_user_factory') do
            expect(subject).to eq(refined_rbs_list)
          end
        end
      end
    end

    context 'with mode=chat' do
      before do
        RbsGoose.configure do |c|
          c.use_ollama(model_name: 'codegemma', mode: :chat)
        end
      end

      it 'returns refined rbs' do
        VCR.use_cassette('ollama_codegemma_chat/infer_user_factory') do
          expect(subject).to eq(refined_rbs_list)
        end
      end
    end
  end

  describe '#fix_error' do
    subject { type_inferrer.fix_error(target_group) }

    let(:example_group) do
      RbsGoose::IO::ExampleGroup.load_from(fixture_path('examples/fix_errors_user_factory'))
    end

    context 'with openai llm', :configure do
      context 'with mode=complete' do
        before do
          RbsGoose.configuration.llm.mode = :complete
        end

        it 'returns refined rbs' do
          VCR.use_cassette('openai_complete/fix_error_user_factory') do
            allow(type_inferrer).to receive(:steep_check).and_return(example_group.error_messages)
            expect(subject).to eq(refined_rbs_list)
          end
        end
      end

      context 'with mode=chat' do
        before do
          RbsGoose.configuration.llm.mode = :chat
        end

        it 'returns refined rbs' do
          VCR.use_cassette('openai_chat/fix_error_user_factory') do
            allow(type_inferrer).to receive(:steep_check).and_return(example_group.error_messages)
            expect(subject).to eq(refined_rbs_list)
          end
        end
      end
    end
  end
end
