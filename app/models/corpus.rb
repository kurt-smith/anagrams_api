# frozen_string_literal: true

class Corpus
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  store_in collection: 'corpus'

  field :word, type: String
  field :proper_noun, type: Boolean, default: false
  field :characters, type: String, default: nil

  scope :anagrams, ->(word) { where(characters: Anagramify.sort(word)).excludes(word: word) }

  index({ word: -1 }, unique: true, name: 'unique_word_index')
  index({ word: -1, characters: -1 }, unique: true, name: 'unique_word_characters_index')

  validates :word, presence:   { message: 'is required' },
                   uniqueness: { conditions: -> { where(deleted_at: nil) },
                                 message: 'already exists in corpus: %{value}',
                                 case_insensitive: false },
                   length:     { minimum: 1, maximum: 255,
                                 message: 'must have more than 1 and less than 255 characters' }

  validates :characters, presence: { message: 'is required' }

  before_validation :default_values

  # Sort characters to store in ascending order
  # TODO: Benchmarking
  # @return [String] All alphabet characters included in word in ascending order
  def sort_characters
    self.characters = Anagramify.sort(word)
  rescue StandardError
    nil
  end

  private

  # Sets default values prior to validation
  def default_values
    format_word
    set_proper_noun
    sort_characters
  end

  # Determine if a word is a proper noun if the first letter is capitalized
  # @return [Boolean]
  def set_proper_noun
    char = word[0]
    proper_noun = char.eql?(char.upcase)
    self.proper_noun = proper_noun
  rescue StandardError
    nil
  end

  # @return [String] Formatted word excluding additional spaces
  def format_word
    self.word = word.strip
  end
end
