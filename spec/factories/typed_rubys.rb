# frozen_string_literal: true

FactoryBot.define do
  factory :typed_ruby, class: 'RbsGoose::IO::TypedRuby' do
    ruby { build(:file, :ruby, :with_multi_line_content, line_prefix: 'ruby_line_') }
    rbs { build(:file, :rbs, :with_multi_line_content, line_prefix: 'rbs_line_') }
  end
end
