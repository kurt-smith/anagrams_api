# frozen_string_literal: true

require 'rails_helper'

describe 'Words Create API', type: :request, requests: true do
  let(:headers) do
    {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
    }
  end

  let(:path) { words_path }

  context '#create' do
    it 'returns 201' do
      params = FactoryBot.build(:corpus_request)
      post path, params: params.to_json, headers: headers
      expect(response).to have_http_status 201
      expect(json.keys).to_not include('errors')
      expect(json.keys).to contain_exactly(*JsonKeyHelper.words)
      expect(json['words'].first.keys).to contain_exactly(*JsonKeyHelper.word)
    end

    it 'returns 201 for multiple words' do
      params = FactoryBot.build(:corpus_request, :multiple_words)
      post path, params: params.to_json, headers: headers
      expect(response).to have_http_status 201
      expect(json.keys).to_not include('errors')
      expect(json.keys).to contain_exactly(*JsonKeyHelper.words)
      expect(json['words'].count).to eq(params[:words].count)
      expect(json['words'].first.keys).to contain_exactly(*JsonKeyHelper.word)
    end

    it 'persists unique words and returns 201' do
      params = {
        words: %w[unique unique]
      }
      post path, params: params.to_json, headers: headers
      expect(response).to have_http_status 201
      expect(json.keys).to_not include('errors')
      expect(json.keys).to contain_exactly(*JsonKeyHelper.words)
      expect(json['words'].count).to eq(1)
      expect(json['words'].first.keys).to contain_exactly(*JsonKeyHelper.word)
      expect(Corpus.count).to eq(1)
    end

    it 'returns 201 when restoring soft deleted word' do
      corpus = FactoryBot.create(:corpus)
      corpus.destroy

      params = FactoryBot.build(:corpus_request, words: [corpus[:word]])

      post path, params: params.to_json, headers: headers
      expect(response).to have_http_status 201
      expect(json.keys).to_not include('errors')
      expect(json.keys).to contain_exactly(*JsonKeyHelper.words)
      expect(json['words'][0].keys).to contain_exactly(*JsonKeyHelper.word)
      expect(json['words'][0]['word']).to eq(corpus[:word])
    end

    it 'returns 422 when not array' do
      params = FactoryBot.build(:corpus_request, words: nil)
      post path, params: params.to_json, headers: headers
      expect(response).to have_http_status 422
      expect(json.keys).to include('errors')
      expect(json['errors'][0]).to eq('invalid param type: array required')
    end

    it 'returns 422 when word already exists' do
      FactoryBot.create(:corpus, word: 'read')
      params = FactoryBot.build(:corpus_request, words: %w[read dare dear])
      post path, params: params.to_json, headers: headers
      expect(response).to have_http_status 422
      expect(json.keys).to include('errors')
      expect(json['errors'][0]['word'][0]).to eq('already exists in corpus: read')
    end
  end
end
