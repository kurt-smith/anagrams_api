# frozen_string_literal: true

class CorpusWorker
  include Sidekiq::Worker
  sidekiq_options queue: :corpus, retry: 1

  # Persists new word for corpus
  # @param opts [Hash]
  # @option word [String]
  def perform(opts)
    options = opts.deep_symbolize_keys
    validate_options!(options)
    word = Corpus.new(word: options[:word])
    word.save_or_restore! if word.valid?
  end

  protected

  # @param opts [Hash]
  # @option word [Hash]
  # @raise [ArgumentError]
  def validate_options!(opts)
    raise ArgumentError.new('word required') if opts.blank? || opts[:word].blank?
  end
end
