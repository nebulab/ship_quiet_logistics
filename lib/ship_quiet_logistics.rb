require 'aws-sdk'
require 'nokogiri'
require 'spree_core'

require 'ship_quiet_logistics/version'
require 'ship_quiet_logistics/api'
require 'ship_quiet_logistics/documents'
require 'ship_quiet_logistics/downloader'
require 'ship_quiet_logistics/event_message'
require 'ship_quiet_logistics/messages'
require 'ship_quiet_logistics/processor'
require 'ship_quiet_logistics/receiver'
require 'ship_quiet_logistics/sender'
require 'ship_quiet_logistics/uploader'
require 'ship_quiet_logistics/version'

module ShipQuietLogistics
  module Commands
    class SendShipment
      def self.call(shipment)
      end
    end
  end

  def self.send_shipment(shipment)
    Commands::SendShipment.(shipment)
  end
end
