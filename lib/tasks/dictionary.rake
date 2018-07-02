# frozen_string_literal: true

namespace :dictionary do
  Rails.logger = Logger.new(STDOUT) unless Rails.env.test?

  desc 'Enqueue CorpusWorker to persist words found in vendor/dictionary/dictionary.txt.gz. '\
    'Limit: defaults to 1_000; 0 processes all words'

  task :enqueue, %i[limit sort] => :environment do |_t, args|
    limit = args[:limit]&.to_i || 1_000
    sort = args[:sort].presence&.to_sym || :asc

    Rails.logger.debug(message: 'Seeding Corpus from dictionary', limit: limit, sort: sort)

    begin
      words = case sort
              when :desc
                limit.eql?(0) ? Dictionary::Words.reverse : Dictionary::Words.last(limit)
              else
                limit.eql?(0) ? Dictionary::Words : Dictionary::Words.first(limit)
              end

      words.each_with_index { |word, index| CorpusWorker.perform_in((0.25 * index).seconds, word: word) }
    rescue StandardError => e
      Rails.logger.error(error: 'Error encountered during dictionary seed task', message: e.message)
    end
  end
end
