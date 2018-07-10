# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
# require 'active_job/railtie'
# require "active_record/railtie"
require 'action_controller/railtie'
# require 'action_mailer/railtie'
require 'action_view/railtie'
# require 'action_cable/engine'
# require 'sprockets/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  module Config
    APP_NAME = 'anagrams_api'
    MONGODB_URI = ENV.fetch('MONGODB_URI') { "mongodb://localhost:27017/anagrams_#{Rails.env}" }
    DB_MAX_CONNECTIONS = ENV.fetch('DB_MAX_CONNECTIONS') { 16 }
    DB_MIN_CONNECTIONS = ENV.fetch('DB_MIN_CONNECTIONS') { 5 }
    DB_WAIT_QUEUE_TIMEOUT = ENV.fetch('DB_WAIT_QUEUE_TIMEOUT') { 5 }
    DB_CONNECT_TIMEOUT = ENV.fetch('DB_CONNECT_TIMEOUT') { 10 }
    DB_SOCKET_TIMEOUT = ENV.fetch('DB_SOCKET_TIMEOUT') { 5 }
    REDIS_CACHE_URL = ENV.fetch('REDIS_CACHE_URL') { 'redis://localhost:6379/0' }
    REDIS_WORKER_URL = ENV.fetch('REDIS_WORKER_URL') { 'redis://localhost:6379/1' }
  end

  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
