require 'aws-sdk'
require 'nokogiri'
require 'spree_core'
require 'gentle'

require 'ship_quiet_logistics/version'
require 'ship_quiet_logistics/engine'
require 'ship_quiet_logistics/api'
require 'ship_quiet_logistics/documents'
require 'ship_quiet_logistics/commands'
require 'ship_quiet_logistics/downloader'
require 'ship_quiet_logistics/event_message'
require 'ship_quiet_logistics/handlers'
require 'ship_quiet_logistics/messages'
require 'ship_quiet_logistics/processor'
require 'ship_quiet_logistics/receiver'
require 'ship_quiet_logistics/sender'
require 'ship_quiet_logistics/uploader'
require 'ship_quiet_logistics/version'

module ShipQuietLogistics
  def self.send_shipment(shipment)
    Commands::SendShipment.(shipment)
  end

  def self.send_rma(rma)
    Commands::SendRma.(rma)
  end

  def self.process_shipments
    client = Gentle::Client.new(configuration.gentle)
    blackboard = Gentle::Blackboard.new(client)
    queue = Gentle::Queue.new(client)

    Commands::Processor.(blackboard: blackboard, queue: queue)
  end

  def self.request_inventory_summary(warehouse_name)
    Commands::InventorySummary.(warehouse_name)
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new

    configuration.error_message_handler = Handlers::ErrorMessageHandler
    configuration.process_shipment_handler = Handlers::ProcessShipmentHandler
    configuration.process_rma_handler = Handlers::ProcessRMAHandler
    configuration.process_inventory_summary_handler = Handlers::ProcessInventorySummaryHandler

    yield configuration
  end

  class Configuration
    attr_accessor :outgoing_bucket,
                  :outgoing_queue,
                  :incoming_bucket,
                  :incoming_queue,
                  :inventory_queue,
                  :business_unit,
                  :client_id,
                  :access_key_id,
                  :secret_access_key,
                  :error_message_handler,
                  :process_shipment_handler,
                  :process_rma_handler,
                  :process_inventory_summary_handler


    def aws
      {
        access_key_id: access_key_id,
        secret_access_key: secret_access_key
      }
    end

    def gentle
      aws.merge \
        client_id: client_id,
        business_unit: business_unit,
        warehouse: 'ALL',
        buckets: {
          to: outgoing_bucket,
          from: incoming_bucket
        },
        queues: {
          to: outgoing_queue,
          from: incoming_queue,
          inventory: inventory_queue
        }
    end
  end
end
