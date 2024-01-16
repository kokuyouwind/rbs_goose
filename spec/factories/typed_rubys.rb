# frozen_string_literal: true

FactoryBot.define do
  factory :typed_ruby, class: 'RbsGoose::IO::TypedRuby' do
    ruby factory: %i[file ruby]
    rbs factory: %i[file rbs]
  end
end
