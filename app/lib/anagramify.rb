# frozen_string_literal: true

# Sorts word by characters in ascending order
# @param word [String] Word to sort
# @return [String]
module Anagramify
  def self.sort(word)
    word.downcase.remove(/[^a-z]/).split(//).sort.join
  end
end
