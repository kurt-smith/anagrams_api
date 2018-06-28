# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'
require 'shoulda/matchers'
require 'rake'
require 'json_spec'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
Rails.application.load_tasks

RSpec.configure do |config|
  Mongo::Logger.logger.level = Logger::WARN
  config.include Rails.application.routes.url_helpers
  config.infer_spec_type_from_file_location!
  config.include Requests::JsonHelpers, type: :request
end
