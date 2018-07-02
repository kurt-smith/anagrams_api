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
    word.save! if word.valid?
  rescue Mongo::Error::OperationFailure => e
    Sidekiq.logger.info(error: 'Mongo error encountered', message: e.message, word: options[:word])
    Corpus.unscoped.find_by(word: options[:word]).restore if e.message.include?('duplicate key error index')
  end

  protected

  # @param opts [Hash]
  # @option word [Hash]
  # @raise [ArgumentError]
  def validate_options!(opts)
    raise ArgumentError.new('word required') if opts.blank? || opts[:word].blank?
  end
end
