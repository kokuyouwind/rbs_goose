# frozen_string_literal: true

FactoryBot.define do
  factory :example, class: 'RbsGoose::IO::Example' do
    typed_ruby { build(:typed_ruby) }
    refined_rbs { build(:file, :rbs, :with_multi_line_content, line_prefix: 'refined_rbs_line_') }
  end
end
