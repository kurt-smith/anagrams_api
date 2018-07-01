# frozen_string_literal: true

sidekiq_config = {
  url: App::Config::REDIS_WORKER_URL,
  network_timeout: 5
}

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config

  database_url = ENV.fetch('MONGODB_URI') { "mongodb://localhost:27017/anagrams_#{Rails.env}" }
  ENV['DATABASE_URL'] = "#{database_url}?pool=10" if database_url.present?
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end
