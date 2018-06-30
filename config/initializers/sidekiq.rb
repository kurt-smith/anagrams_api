# frozen_string_literal: true

sidekiq_config = {
  url: App::Config::REDIS_WORKER_URL,
  network_timeout: 5
}

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end
