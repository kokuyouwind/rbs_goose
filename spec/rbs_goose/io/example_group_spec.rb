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
      expect(subject).to include(:company_repository)
      expect(subject[:company_repository].count).to eq(1)
      expect(subject[:company_repository][0]).to have_attributes(
        typed_ruby: have_attributes(
          ruby: have_attributes(
            path: 'lib/company_repository.rb'
          ),
          rbs: have_attributes(
            path: 'sig/company_repository.rbs'
          )
        ),
        refined_rbs: have_attributes(
          path: 'sig/company_repository.rbs'
        )
      )
    end
  end
end
