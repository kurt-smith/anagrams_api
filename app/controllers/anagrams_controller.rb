# frozen_string_literal: true

class AnagramsController < ApplicationController
  # Returns anagrams based on word param
  # method:: GET
  # response_format:: json
  #
  # http_response:: [200 OK] Indicates the request was received and a result was returned.
  # http_response:: [404 Not Found] Indicates that the result could not be found by criteria.
  #
  # request_url:: /anagrams/:word_name
  #
  # @return [JSON] List of created records
  # TODO Add pagination
  def show
    query = Corpus.anagrams(params[:word_name].strip)
    @anagrams = query.limit(request_params[:limit]).sort(word: request_params[:sort])
    @meta = request_params.tap do |x|
      x[:total] = query.count
      x[:word] = params[:word_name]
    end

    render status: 200
  end
end
