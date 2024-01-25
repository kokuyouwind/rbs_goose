# frozen_string_literal: true

RSpec.describe RbsGoose::IO::TargetGroup do
  describe '.load_from' do
    subject { described_class.load_from(fixture_path('targets/test')) }

    it 'load target groups' do
      expect(subject).to be_a(described_class).and contain_exactly(
        be_a(RbsGoose::IO::TypedRuby)
      )
      expect(subject[0].ruby).to have_attributes(
        path: 'lib/test.rb',
        content: 'def test; end'
      )
      expect(subject[0].rbs).to have_attributes(
        path: 'sig/test.rbs',
        content: 'def test: untyped'
      )
    end
  end
end
