# frozen_string_literal: true

require 'rails_helper'

describe CorpusWorker, type: :worker do
  it { expect { subject.send(:validate_options!, nil) }.to raise_error(ArgumentError, 'word required') }

  context '#perform' do
    let(:word) { FactoryBot.build(:corpus) }

    it 'persists word' do
      expect(Corpus.count).to eq(0)
      Sidekiq::Testing.inline! { subject.perform(word: word[:word]) }
      expect(Corpus.count).to eq(1)

      word = Corpus.first
      expect(word[:word]).to eq(word[:word])
    end

    it 'doesn\'t raises error and does not process if word exists in corpus' do
      word.save
      expect(Corpus.count).to eq(1)
      Sidekiq::Testing.inline! do
        expect { subject.perform(word: word[:word]) }.not_to raise_error
      end
    end
  end
end
