# frozen_string_literal: true

require 'rails_helper'

describe 'Anagrams API', type: :request, requests: true do
  let(:headers) do
    {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
    }
  end

  context '#show' do
    let(:word) { 'read' }
    let(:path) { anagram_path(word) }
    let(:word_list) { %w[read dare dear] }
    let(:anagram) { word_list - [word] }

    before(:each) { word_list.each { |w| FactoryBot.create(:word, name: w) } }

    it 'returns 200' do
      get path, headers: headers
      expect(response).to have_http_status 200
      expect(json.keys).to_not include('errors')
      expect(json.keys).to contain_exactly(*JsonKeyHelper.anagrams)
      expect(json['meta'].keys).to contain_exactly(*JsonKeyHelper.anagrams_meta)
      expect(json['meta']['total']).to eq(anagram.count)
      expect(json['anagrams']).to be_a(Array)
      expect(json['anagrams']).to contain_exactly(*anagram.sort)
    end

    it 'returns 200 with limit' do
      params = { limit: 1 }

      get path + "?#{params.to_param}", headers: headers
      expect(response).to have_http_status 200
      expect(json.keys).to_not include('errors')
      expect(json.keys).to contain_exactly(*JsonKeyHelper.anagrams)
      expect(json['meta'].keys).to contain_exactly(*JsonKeyHelper.anagrams_meta)
      expect(json['meta']['sort']).to eq('asc')
      expect(json['meta']['total']).to eq(anagram.count)
      expect(json['anagrams']).to be_a(Array)
      expect(json['anagrams'].count).to eq(params[:limit])
    end

    it 'returns 200 with sort descending' do
      params = { sort: '-' }

      get path + "?#{params.to_param}", headers: headers
      expect(response).to have_http_status 200
      expect(json.keys).to_not include('errors')
      expect(json.keys).to contain_exactly(*JsonKeyHelper.anagrams)
      expect(json['meta'].keys).to contain_exactly(*JsonKeyHelper.anagrams_meta)
      expect(json['meta']['total']).to eq(anagram.count)
      expect(json['meta']['sort']).to eq('desc')
      expect(json['anagrams']).to contain_exactly(*anagram.sort.reverse)
    end
  end
end
