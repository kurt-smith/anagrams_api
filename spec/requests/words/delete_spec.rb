# frozen_string_literal: true

require 'rails_helper'

describe 'Words Delete API', type: :request, requests: true do
  let(:headers) do
    {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
    }
  end

  context '#destroy' do
    let(:word) { FactoryBot.create(:corpus)[:word] }
    let(:path) { word_path(word) }

    it 'returns 204' do
      delete path, headers: headers
      expect(response).to have_http_status 204
      expect(response.body).to be_empty
    end

    it 'returns 404 when word doesn\'t exist' do
      non_word = FactoryBot.build(:corpus)[:word]
      path = word_path(non_word)
      delete path, headers: headers
      expect(response).to have_http_status 404
      expect(json.keys).to contain_exactly('errors')
      expect(json['errors'][0]).to eq("Not found in corpus: #{non_word}")
    end
  end
end
