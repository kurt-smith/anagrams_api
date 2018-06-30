# frozen_string_literal: true

FactoryBot.define do
  factory :word do
    name { Faker::Hipster.unique.word }
  end

  factory :word_request, class: Hash do
    words { [Faker::Hacker.unique.verb] }

    trait :multiple_words do
      words do
        arr = []
        10.times { arr << Faker::Hacker.unique.verb }
        arr
      end
    end

    initialize_with { attributes }
  end
end
