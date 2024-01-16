# frozen_string_literal: true

FactoryBot.define do
  factory :file, class: 'RbsGoose::IO::File' do
    path { 'example_file.rb' }
    content { 'example_content' }

    trait :ruby do
      path { 'example_ruby.rb' }
      content { "ruby_line_1\nruby_line_2\nruby_line_3" }
    end

    trait :rbs do
      path { 'example_rbs.rbs' }
      content { "rbs_line_1\nrbs_line_2\nrbs_line_3" }
    end
  end
end
