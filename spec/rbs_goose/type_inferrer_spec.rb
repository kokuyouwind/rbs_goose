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

      before do
        RbsGoose.configure do |c|
          c.instruction = <<~INSTRUCTION
            Act as Ruby type inferrer.
            When ruby source codes and RBS type signatures are given, refine each RBS type signatures. Each file should be split in markdown code format.
            Use class names, variable names, etc., to infer type.
          INSTRUCTION
          c.example_groups = [RbsGoose::IO::ExampleGroup.default_examples[:rbs_samples]]
          c.use_open_ai(ENV.fetch('OPENAI_ACCESS_TOKEN'))
        end
      end

      it 'returns refined rbs' do
        VCR.use_cassette('openai/infer_user_factory') do
          expect(subject).to eq(refined_rbs_list)
        end
      end
    end
  end
end
