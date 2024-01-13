# frozen_string_literal: true

RSpec.describe RbsGoose::IO::File do
  let(:ruby_file) { described_class.new('user_factory.rb', content: user_factory_code) }
  let(:rbs_file) { described_class.new('user_factory.rbs', content: user_factory_rbs) }

  let(:user_factory_code) do
    <<~RUBY
      class UserFactory
        def name(name)
          @name = name
          self
        end

        def build
          User.new(name: name)
        end
      end
    RUBY
  end

  let(:user_factory_rbs) do
    <<~RBS
      class UserFactory
        def name: (untyped name) -> untyped

        def build: () -> untyped
      end
    RBS
  end

  let(:user_factory_refined_rbs) do
    <<~REFINED_RBS
      class UserFactory
        def name: (String name) -> UserFactory

        def build: () -> User
      end
    REFINED_RBS
  end

  describe '#type' do
    context 'when ruby file' do
      subject { ruby_file.type }

      it 'returns ruby' do
        expect(subject).to eq(:ruby)
      end
    end

    context 'when rbs file' do
      subject { rbs_file.type }

      it 'returns rbs' do
        expect(subject).to eq(:rbs)
      end
    end
  end

  describe '#to_s' do
    subject { ruby_file.to_s }

    context 'when ruby file' do
      it 'returns ruby markdown' do
        expect(subject).to eq(<<~MARKDOWN)
          ```ruby:user_factory.rb
          #{user_factory_code.strip}
          ```
        MARKDOWN
      end
    end

    context 'when rbs file' do
      subject { rbs_file.to_s }

      it 'returns rbs markdown' do
        expect(subject).to eq(<<~MARKDOWN)
          ```rbs:user_factory.rbs
          #{user_factory_rbs.strip}
          ```
        MARKDOWN
      end
    end
  end

  describe '#content=' do
    subject do
      rbs_file.content = user_factory_refined_rbs
      rbs_file.content
    end

    it 'sets content' do
      expect(subject).to eq(user_factory_refined_rbs.strip)
    end
  end
end
