require 'aws-sdk'
require 'nokogiri'
require 'spree_core'

require 'ship_quiet_logistics/version'
require 'ship_quiet_logistics/engine'
require 'ship_quiet_logistics/api'
require 'ship_quiet_logistics/documents'
require 'ship_quiet_logistics/commands'
require 'ship_quiet_logistics/downloader'
require 'ship_quiet_logistics/event_message'
require 'ship_quiet_logistics/messages'
require 'ship_quiet_logistics/processor'
require 'ship_quiet_logistics/receiver'
require 'ship_quiet_logistics/sender'
require 'ship_quiet_logistics/uploader'
require 'ship_quiet_logistics/version'

AWS.config(access_key_id: ENV['AMAZON_ACCESS_KEY'],
           secret_access_key: ENV['AMAZON_SECRET_KEY'])

module ShipQuietLogistics
  def self.send_shipment(shipment)
    Commands::SendShipment.(shipment)
  end

  def self.process_shipments
    Commands::ProcessShipments.()
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new

    yield configuration
  end

  class Configuration
    attr_accessor :outgoing_bucket,
                  :outgoing_queue,
                  :incoming_bucket,
                  :incoming_queue,
                  :business_unit,
                  :client_id
  end
end
