# frozen_string_literal: true

namespace :dictionary do
  Rails.logger = Logger.new(STDOUT) unless Rails.env.test?

  desc 'Enqueue CorpusWorker to persist words found in vendor/dictionary/dictionary.txt.gz. '\
    'Limit: defaults to 1_000; 0 processes all words'

  task :enqueue, %i[limit] => :environment do |_t, args|
    limit = args.limit&.to_i || 1_000
    Rails.logger.debug(message: 'Seeding Corpus from dictionary', limit: limit)

    begin
      words = limit.eql?(0) ? Dictionary::Words : Dictionary::Words.first(limit)
      words.each { |word| CorpusWorker.perform_async(word: word) }
    rescue StandardError => e
      Rails.logger.error(error: 'Error encountered during dictionary seed task', message: e.message)
    end
  end
end
