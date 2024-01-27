# frozen_string_literal: true

RSpec.describe RbsGoose::TypeInferrer, :configure do
  let(:example_group) do
    RbsGoose::IO::ExampleGroup.load_from(fixture_path('examples/user_factory'))
  end
  let(:target_group) { example_group.to_target_group }
  let(:refined_rbs_list) { example_group.to_refined_rbs_list }

  describe '#infer', :configure do
    context 'with DefaultTemplate' do
      subject { described_class.new.infer(target_group) }

      it 'returns refined rbs' do
        VCR.use_cassette('openai/infer_user_factory') do
          expect(subject).to eq(refined_rbs_list)
        end
      end
    end
  end
end
