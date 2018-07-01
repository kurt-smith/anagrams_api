# frozen_string_literal: true

json.words do
  json.array! @words do |word|
    json.partial! 'shared/word', word: word
  end
end
