ENV['RAILS_ENV'] = 'test'

begin
  require File.expand_path('../dummy/config/environment', __FILE__)
rescue LoadError
  puts 'Could not load dummy application. Please ensure you have run `bundle exec rake test_app`'
  exit
end

require 'ship_quiet_logistics'
require 'database_cleaner'
require 'dotenv'
require 'ffaker'
require 'pry'
require 'rspec/rails'

require 'spree/testing_support/factories'

Dotenv.load

Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each { |f| require f }

ShipQuietLogistics.configure do |config|
  config.outgoing_bucket  = ENV['OUTGOING_BUCKET']
  config.outgoing_queue   = ENV['OUTGOING_QUEUE']
  config.business_unit    = ENV['BUSINESS_UNIT']
  config.client_id        = ENV['CLIENT_ID']
end

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before do
    FactoryGirl.find_definitions
  end

  config.use_transactional_fixtures = false
end
