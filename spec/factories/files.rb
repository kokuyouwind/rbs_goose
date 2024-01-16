# frozen_string_literal: true

FactoryBot.define do
  factory :file, class: 'RbsGoose::IO::File' do
    path { 'example_file.rb' }
    content { 'example_content' }

    trait :ruby do
      path { 'example_ruby.rb' }
    end

    trait :rbs do
      path { 'example_rbs.rbs' }
      content { "rbs_line_1\nrbs_line_2\nrbs_line_3" }
    end

    trait :with_multi_line_content do
      transient do
        line_prefix { 'line_' }
        line_count { 3 }
      end

      after(:build) do |file, evaluator|
        file.content = (1..evaluator.line_count).map { |n| "#{evaluator.line_prefix}#{n}" }.join("\n")
      end
    end
  end
end
