# frozen_string_literal: true

RSpec.describe RbsGoose::TypeInferrer do
  let(:user_factory_code) do
    <<~RUBY
      ```ruby:user_factory.rb
      class UserFactory
        def name(name)
          @name = name
          self
        end

        def build
          User.new(name: name)
        end
      end
      ```
    RUBY
  end

  let(:user_factory_rbs) do
    <<~RBS
      ```rbs:user_factory.rbs
      class UserFactory
        def name: (untyped name) -> untyped

        def build: () -> untyped
      end
      ```
    RBS
  end

  let(:user_factory_refined_rbs) do
    <<~REFINED_RBS
      ```rbs:user_factory.rbs
      class UserFactory
        def name: (String name) -> UserFactory

        def build: () -> User
      end
      ```
    REFINED_RBS
  end

  describe '#infer' do
    subject { described_class.new.infer(user_factory_code, user_factory_rbs) }

    it 'returns refined rbs' do
      VCR.use_cassette('openai/infer_user_factory') do
        expect(subject).to eq(user_factory_refined_rbs.strip)
      end
    end
  end
end
