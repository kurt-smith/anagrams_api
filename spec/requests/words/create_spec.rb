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
      params = FactoryBot.build(:word_request)
      post path, params: params.to_json, headers: headers
      expect(response).to have_http_status 201
      expect(json.keys).to_not include('errors')
      expect(json.keys).to contain_exactly(*JsonKeyHelper.words)
      expect(json['words'].first.keys).to contain_exactly(*JsonKeyHelper.word)
    end

    it 'returns 201 for multiple words' do
      params = FactoryBot.build(:word_request, :multiple_words)
      post path, params: params.to_json, headers: headers
      expect(response).to have_http_status 201
      expect(json.keys).to_not include('errors')
      expect(json.keys).to contain_exactly(*JsonKeyHelper.words)
      expect(json['words'].count).to eq(params[:words].count)
      expect(json['words'].first.keys).to contain_exactly(*JsonKeyHelper.word)
    end

    it 'returns 422 when not array' do
      params = FactoryBot.build(:word_request, words: nil)
      post path, params: params.to_json, headers: headers
      expect(response).to have_http_status 422
      expect(json.keys).to include('errors')
      expect(json['errors'][0]).to eq('invalid param type: array required')
    end

    it 'returns 422 when word already exists' do
      FactoryBot.create(:word, name: 'Ibotta')
      params = FactoryBot.build(:word_request, words: %w[Ibotta cash back rewards])
      post path, params: params.to_json, headers: headers
      expect(response).to have_http_status 422
      expect(json.keys).to include('errors')
      expect(json['errors'][0]['name'][0]).to eq('already exists in corpus: Ibotta')
    end
  end
end
