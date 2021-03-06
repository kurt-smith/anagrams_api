# frozen_string_literal: true

require 'rails_helper'

describe 'Delete All Words API', type: :request, requests: true do
  let(:headers) do
    {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
    }
  end

  context '#destroy_all' do
    let(:count) { 10 }
    let!(:word) { FactoryBot.create_list(:corpus, count) }
    let(:path) { all_words_path }

    it 'returns 204' do
      expect(Corpus.count).to eq(count)
      delete path, headers: headers
      expect(response).to have_http_status 204
      expect(response.body).to be_empty
      expect(Corpus.count).to eq(0)
    end
  end
end
