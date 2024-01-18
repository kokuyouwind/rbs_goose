# frozen_string_literal: true

FactoryBot.define do
  factory :example, class: 'RbsGoose::IO::Example' do
    typed_ruby { build(:typed_ruby) }
    refined_rbs { build(:refined_rbs) }
  end
end
