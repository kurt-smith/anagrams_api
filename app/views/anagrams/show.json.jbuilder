# frozen_string_literal: true

json.meta @meta
json.anagrams do
  json.array! @anagrams.collect { |a| a.word }
end
