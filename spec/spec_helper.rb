# frozen_string_literal: true

require 'database_cleaner'
require 'simplecov'

SimpleCov.start 'rails'

RSpec.configure do |config|
  config.order = :random

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
