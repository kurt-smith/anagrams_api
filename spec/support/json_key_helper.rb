# frozen_string_literal: true

module JsonKeyHelper
  def self.words
    %w[words]
  end

  def self.word
    %w[word proper_noun]
  end

  def self.request_params
    %w[limit offset sort]
  end

  def self.anagrams_meta
    JsonKeyHelper.request_params + %w[total word]
  end

  def self.anagrams
    %w[meta anagrams]
  end
end
