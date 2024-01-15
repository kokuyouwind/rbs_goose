# frozen_string_literal: true

RSpec.describe RbsGoose::TypeInferrer, :configure do
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

  let(:user_factory_typed) do
    RbsGoose::IO::TypedRuby.new(
      RbsGoose::IO::File.new(path: 'user_factory.rb', content: user_factory_code),
      RbsGoose::IO::File.new(path: 'user_factory.rbs', content: user_factory_rbs)
    )
  end

  let(:user_factory_refined_rbs) do
    <<~REFINED_RBS
      class UserFactory
        def name: (String name) -> UserFactory

        def build: () -> User
      end
    REFINED_RBS
  end

  describe '#infer' do
    subject { described_class.new.infer(user_factory_typed) }

    it 'returns refined rbs' do
      VCR.use_cassette('openai/infer_user_factory') do
        expect(subject).to contain_exactly(
          be_a(RbsGoose::IO::File)
            .and(have_attributes(
                   path: 'user_factory.rbs',
                   content: user_factory_refined_rbs.strip
                 ))
        )
      end
    end
  end
end
