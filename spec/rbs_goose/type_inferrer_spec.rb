# frozen_string_literal: true

RSpec.describe RbsGoose::TypeInferrer, :configure do
  let(:target_group) do
    RbsGoose::IO::TargetGroup.load_from(fixture_path('targets/user_factory'))
  end

  let(:refined_rbs) do
    RbsGoose::IO::File.new(path: 'sig/user_factory.rbs', base_path: fixture_path('targets/user_factory/refined'))
  end

  describe '#infer', :configure do
    context 'with DefaultTemplate' do
      subject { described_class.new.infer(target_group) }

      it 'returns refined rbs' do
        VCR.use_cassette('openai/infer_user_factory') do
          expect(subject).to contain_exactly(
            be_a(RbsGoose::IO::File)
              .and(have_attributes(
                     path: refined_rbs.path,
                     content: refined_rbs.content
                   ))
          )
        end
      end
    end
  end
end
