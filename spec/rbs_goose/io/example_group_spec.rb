# frozen_string_literal: true

RSpec.describe RbsGoose::IO::ExampleGroup do
  describe '.load_from' do
    subject { described_class.load_from(fixture_path('examples/test')) }

    it 'load example groups' do
      expect(subject).to contain_exactly(
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
        path: 'sig.refined/test.rbs',
        content: 'def test: string'
      )
    end
  end
end
