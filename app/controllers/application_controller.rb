# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_default_request_format
  protect_from_forgery with: :null_session, if: proc { |c| c.request.format =~ %r{application/json} }

  def raise_not_found!
    errors(["No route matches #{params[:unmatched_route]}"], 404)
  end

  protected

  def set_default_request_format
    request.format = :json
  end

  def errors(errors, status)
    @errors = errors
    render('common/error', status: status)
  end

  def load_word
    @word ||= Word.find_by!(name: params[:word_name])
  rescue StandardError
    errors(["Not found in corpus: #{params[:word_name]}"], 404)
  end
end
