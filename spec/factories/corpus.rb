# frozen_string_literal: true

FactoryBot.define do
  factory :corpus do
    word { Dictionary::Words.sample }
  end

  factory :corpus_request, class: Hash do
    words { [Faker::Hacker.unique.verb] }

    trait :multiple_words do
      words do
        arr = []
        10.times { arr << Dictionary::Words.sample }
        arr
      end
    end

    initialize_with { attributes }
  end
end
