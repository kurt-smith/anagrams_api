# frozen_string_literal: true

class Word
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  store_in collection: 'words'

  field :name, type: String
  field :proper_noun, type: Boolean, default: false
  field :characters, type: String, default: nil

  validates :name, presence:   { message: 'is required' },
                   uniqueness: { conditions: -> { where(deleted_at: nil) },
                                 message: 'already exists in corpus',
                                 case_insensitive: false },
                   length:     { minimum: 1, maximum: 255,
                                 message: 'must have more than 1 and less than 255 characters' }

  validates :characters, presence: { message: 'is required' }

  before_validation :default_values

  # Sort characters to store in ascending order
  # TODO: Benchmarking
  # @return [String] All characters included in word in ascending order
  # @note Only supports
  def sort_characters
    self.characters = name.downcase.remove(/[^a-zA-Z]/).split(//).sort.join
  rescue StandardError
    nil
  end

  private

  # Sets default values prior to validation
  def default_values
    format_name
    set_proper_noun
    sort_characters
  end

  # Determine if a word is a proper noun if the first letter is capitalized
  # @return [Boolean]
  def set_proper_noun
    char = name[0]
    proper_noun = char.eql?(char.upcase)
    self.proper_noun = proper_noun
  rescue StandardError
    nil
  end

  # @return [String] Formatted name excluding additional spaces
  def format_name
    self.name = name.strip
  end
end
