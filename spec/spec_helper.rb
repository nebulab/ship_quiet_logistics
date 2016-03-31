ENV['RAILS_ENV'] = 'test'

require 'dotenv'
Dotenv.load!

begin
  require File.expand_path('../dummy/config/environment', __FILE__)
rescue LoadError
  puts 'Could not load dummy application. Please ensure you have run `bundle exec rake test_app`'
  exit
end

require 'database_cleaner'
require 'ffaker'
require 'pry'
require 'rspec/rails'
require 'spree/testing_support/factories'
require 'timecop'

Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before do
    FactoryGirl.find_definitions
  end

  config.use_transactional_fixtures = false
end
