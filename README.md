# ShipQuietLogistics

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/ship_quiet_logistics`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ship_quiet_logistics'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ship_quiet_logistics

Run the install generator

    $ bundle exec rails g ship_quiet_logistics:install

Run its migration

    $ bundle exec rake db:migrate

## Configuration

#### Required Configuration Settings

```ruby
ShipQuietLogistics.configure do |config|
  config.outgoing_bucket   = ENV['QUIET_OUTGOING_BUCKET']
  config.outgoing_queue    = ENV['QUIET_OUTGOING_QUEUE']
  config.incoming_bucket   = ENV['QUIET_INCOMING_BUCKET']
  config.incoming_queue    = ENV['QUIET_INCOMING_QUEUE']
  config.inventory_queue   = ENV['QUIET_INVENTORY_QUEUE']
  config.business_unit     = ENV['QUIET_BUSINESS_UNIT']
  config.client_id         = ENV['QUIET_CLIENT_ID']
  config.access_key_id     = ENV['QUIET_AWS_ACCESS_KEY']
  config.secret_access_key = ENV['QUIET_AWS_SECRET_KEY']
end
```

#### Optional Configuration Settings

```ruby
ShipQuietLogistics.configure do |config|
  config.error_message_handler = # anything that responds to `.call`
  config.process_shipment_handler = # anything that responds to `.call`
end
```

##### The Error Message Handler

Any object that responds to `.call` can be set for error message handler to know more about it please check the implementation under `handlers/error_response_handler`.

##### The Process Shipment Handler

Any object that responds to `.call` can be set for process shipment handler to know more about it please check the implementation under `handlers/process_shipment_handler`.

Additionnaly Quiet Logistics requires a Business Unit and a Client ID

## Usage

To encourage decoupling from what a Spree/Solidus shipment type is, it's a good idea to decorate the shipment we have into the shipment surface API this plugin expects. For guidance on this subject matter please look at the `spec/support/shipment_decorator` for a working decorator. More information on what methods are called on `shipment` can also be found by reading `lib/ship_quiet_logistics/documents/shipment_order`. Reading source code is fun!

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Testing

This project uses RSpec and you can run the tests either by:

    $ bundle exec rake

Or if the dummy app is already installed

    $ bundle exec rspec spec

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ship_quiet_logistics. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.
