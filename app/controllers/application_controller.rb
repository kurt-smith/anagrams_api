# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_default_request_format
  respond_to :json
  protect_from_forgery with: :null_session, if: proc { |c| c.request.format =~ %r{application/json} }

  def raise_not_found!
    errors(["No route matches #{params[:unmatched_route]}"], 404)
  end

  protected

  def set_default_request_format
    request.format = :json
  end

  # @return [JSON] Error response
  def errors(errors, status)
    @errors = errors
    render('common/error', status: status)
  end

  # @return [Corpus] Record found in corpus
  # @note returns error if queried word is not found in database
  def load_word
    @word ||= Corpus.find_by!(word: params[:word_name])
  rescue StandardError
    errors(["Not found in corpus: #{params[:word_name]}"], 404)
  end

  # @return [Hash] Optional query params
  def request_params
    {
      limit: params[:limit].presence&.to_i || 1_000,
      offset: params[:offset].presence&.to_i || 1,
      sort: sort_query_params
    }.compact
  end

  # Optional sorting params for queries
  # @note defaults to ascending order
  def sort_query_params
    case params[:sort].presence
    when '+', 'asc', nil
      :asc
    when '-', 'desc'
      :desc
    else
      :asc
    end
  end
end
