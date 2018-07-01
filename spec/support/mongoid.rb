# frozen_string_literal: true

require 'mongoid-rspec'

RSpec.configure do |config|
  Mongo::Logger.logger.level = Logger::WARN
  config.include Mongoid::Matchers
end
