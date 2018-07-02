# frozen_string_literal: true

class WordsController < ApplicationController
  before_action :load_word, only: %i[destroy]

  # Creates provided unique words
  # method:: POST
  # response_format:: json
  #
  # http_response:: [201 Created] Indicates the request was received and the object was created successfully.
  # http_response:: [422 Unprocessable Entity] An error occurred and an error response has been sent with details.
  #
  # request_url:: /words
  #
  # @param words [Array<String>] Array of strings to persist
  # @return [JSON] List of created records
  # @note No words will be persisted if an error is returned. Only unique words within params will be persisted.
  def create
    word_list = word_params[:words]&.uniq
    return errors(['invalid param type: array required'], 422) unless word_list.is_a?(Array)
    @errors = []

    @words = word_list.each_with_object([]) do |word, arr|
      w = Corpus.new(word: word)

      if w.valid?
        arr << w
      else
        @errors << w.errors
      end
    end

    return errors(@errors, 422) if @errors.present?
    render status: 201 if @words.each(&:save_or_restore)
  end

  # Deletes word param
  # method:: DELETE
  # response_format:: json
  #
  # http_response:: [204 No Content] Indicates the request was received and the object was deleted or does not exist.
  # http_response:: [404 Not Found] Indicates that the result could not be found by criteria.
  #
  # request_url:: /words/:word_name
  # @return [JSON] Deleted record
  def destroy
    render status: 204 if @word.destroy
  end

  # Soft deletes entire corpus
  # method:: DELETE
  # response_format:: json
  #
  # http_response:: [204 No Content] Indicates the request was received and the object was deleted or does not exist.
  #
  # request_url:: /words
  # @return [JSON] Deleted records
  def destroy_all
    render status: 204 if Corpus.destroy_all
  end

  private

  def word_params
    params.permit(words: [])
  end
end
