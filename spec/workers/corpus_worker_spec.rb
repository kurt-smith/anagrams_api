# frozen_string_literal: true

require 'rails_helper'

describe CorpusWorker, type: :worker do
  it { expect { subject.send(:validate_options!, nil) }.to raise_error(ArgumentError, 'word required') }

  context '#perform' do
    it 'persists word' do
      expect(Corpus.count).to eq(0)
      Sidekiq::Testing.inline! { subject.perform(word: 'Ibotta') }
      expect(Corpus.count).to eq(1)

      word = Corpus.first
      expect(word[:word]).to eq('Ibotta')
      expect(word[:proper_noun]).to eq(true)
      expect(word[:characters]).to eq('abiott')
    end

    it 'raises error and does not process if word exists in corpus' do
      FactoryBot.create(:corpus, word: 'Ibotta')
      expect(Corpus.count).to eq(1)
      Sidekiq::Testing.inline! do
        expect { subject.perform(word: 'Ibotta') }.to raise_error(StandardError)
      end
    end
  end
end
