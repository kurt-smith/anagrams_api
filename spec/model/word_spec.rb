# frozen_string_literal: true

require 'rails_helper'

describe Corpus, models: true do
  it { is_expected.to be_mongoid_document }
  it { is_expected.to be_stored_in(collection: 'corpus') }
  it { is_expected.to have_field(:word).of_type(String) }
  it { is_expected.to have_field(:characters).of_type(String).with_default_value_of(nil) }
  it { is_expected.to have_field(:proper_noun).of_type(Mongoid::Boolean).with_default_value_of(false) }
  it { is_expected.to have_timestamps }
  it { is_expected.to have_field(:deleted_at).of_type(Time).with_default_value_of(nil) }

  context 'validations' do
    describe 'word' do
      it { is_expected.to validate_presence_of(:word).with_message('is required') }
      it do
        is_expected.to validate_length_of(:word)
          .within(1..255)
          .with_message('must have more than 1 and less than 255 characters')
      end
      it { is_expected.to validate_uniqueness_of(:word).with_message('already exists in corpus: %{value}') }
    end

    describe 'characters' do
      it { is_expected.to validate_presence_of(:characters).with_message('is required') }
    end
  end

  describe '#sort_characters' do
    it 'sorts characters in ascending order' do
      word = FactoryBot.build(:corpus, word: 'radar')
      expect(word.sort_characters).to eq('aadrr')
    end

    it 'removes non-alphabet characters' do
      word = FactoryBot.build(:corpus, word: ' SU,PER- he&ro! ')
      expect(word.sort_characters).to eq('eehoprrsu')
    end
  end

  describe '#set_proper_noun' do
    it 'returns true when first character is uppercase' do
      word = FactoryBot.build(:corpus, word: 'Ibotta')
      expect(word.send(:set_proper_noun)).to be_truthy
    end

    it 'returns true when all characters is uppercase' do
      word = FactoryBot.build(:corpus, word: 'IBOTTA')
      expect(word.send(:set_proper_noun)).to be_truthy
    end

    it 'returns false when first character is lowercase' do
      word = FactoryBot.build(:corpus, word: 'ibotta')
      expect(word.send(:set_proper_noun)).to be_falsey
    end

    it 'returns false when first character is lowercase' do
      word = FactoryBot.build(:corpus, word: 'iBOTTA')
      expect(word.send(:set_proper_noun)).to be_falsey
    end
  end

  describe '#save' do
    let(:word) { FactoryBot.build(:corpus, word: 'read') }

    it 'persists word' do
      expect(word[:word]).to eq('read')
      expect(word[:proper_noun]).to eq(false)
      expect(word[:characters]).to eq(nil)

      expect(word.valid?).to be_truthy
      expect(word[:word]).to eq('read')
      expect(word[:proper_noun]).to eq(false)
      expect(word[:characters]).to eq('ader')
      expect(word.save!).to be_truthy
    end
  end
end
