# frozen_string_literal: true

RSpec.describe RbsGoose::IO::ExampleGroup do
  describe '.load_from' do
    subject { described_class.load_from(fixture_path('examples/test')) }

    it 'load example groups' do
      expect(subject).to be_a(described_class).and contain_exactly(
        be_a(RbsGoose::IO::Example)
      )
      expect(subject[0].typed_ruby.ruby).to have_attributes(
        path: 'lib/test.rb',
        content: 'def test; end'
      )
      expect(subject[0].typed_ruby.rbs).to have_attributes(
        path: 'sig/test.rbs',
        content: 'def test: untyped'
      )
      expect(subject[0].refined_rbs).to have_attributes(
        path: 'sig/test.rbs',
        content: 'def test: string'
      )
    end
  end

  describe '.default_examples' do
    subject { described_class.default_examples }

    it 'returns example groups' do
      expect(subject.keys).to eq(%i[rbs_samples])
      expect(subject[:rbs_samples]).to contain_exactly(
        be_a(RbsGoose::IO::Example).and(have_attributes(refined_rbs: have_attributes(path: 'sig/email.rbs'))),
        be_a(RbsGoose::IO::Example).and(have_attributes(refined_rbs: have_attributes(path: 'sig/person.rbs'))),
        be_a(RbsGoose::IO::Example).and(have_attributes(refined_rbs: have_attributes(path: 'sig/phone.rbs')))
      )
    end
  end

  describe 'to_target_group' do
    subject { example_group.to_target_group }

    let(:example_group) { described_class.load_from(fixture_path('examples/test')) }

    it 'returns target group' do
      expect(subject).to be_a(RbsGoose::IO::TargetGroup)
        .and contain_exactly(be_a(RbsGoose::IO::TypedRuby))
      expect(subject[0]).to have_attributes(
        ruby: have_attributes(
          path: 'lib/test.rb'
        ),
        rbs: have_attributes(
          path: 'sig/test.rbs'
        )
      )
    end
  end

  describe 'to_refined_rbs_list' do
    subject { example_group.to_refined_rbs_list }

    let(:example_group) { described_class.load_from(fixture_path('examples/test')) }

    it 'returns refined rbs list' do
      expect(subject).to be_a(Array)
        .and contain_exactly(be_a(RbsGoose::IO::File))
      expect(subject[0]).to have_attributes(
        path: 'sig/test.rbs'
      )
    end
  end
end
