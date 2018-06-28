# frozen_string_literal: true

require 'factory_bot'
require 'database_cleaner'
require 'simplecov'
require 'webmock/rspec'

SimpleCov.start 'rails'
WebMock.allow_net_connect!

RSpec.configure do |config|
  config.order = :random
  config.include FactoryBot::Syntax::Methods
end

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner[:mongoid].strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
