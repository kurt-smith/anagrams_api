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
    Word.create!(name: options[:word])
  end

  protected

  # @param opts [Hash]
  # @option word [Hash]
  # @raise [ArgumentError]
  def validate_options!(opts)
    raise ArgumentError.new('word required') if opts.blank? || opts[:word].blank?
  end
end
