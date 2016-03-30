module ShipQuietLogistics
  class DummyProcessShipmentHandler
    def self.call(document)
      shipment = Spree::Shipment.find_by(number: document.order_number)

      shipment.ship!
      shipment.update(tracking: document.tracking_number)
    end
  end

  class DummyErrorMessageHandler
    def self.call(message)
      shipment = Spree::Shipment.find_by(number: message.shipment_number)

      shipment.update(pushed: false)
    end
  end
end

ShipQuietLogistics.configure do |config|
  config.outgoing_bucket  = ENV['QUIET_OUTGOING_BUCKET']
  config.outgoing_queue   = ENV['QUIET_OUTGOING_QUEUE']
  config.incoming_bucket  = ENV['QUIET_INCOMING_BUCKET']
  config.incoming_queue   = ENV['QUIET_INCOMING_QUEUE']
  config.inventory_queue  = ENV['QUIET_INVENTORY_QUEUE']
  config.business_unit    = ENV['QUIET_BUSINESS_UNIT']
  config.client_id        = ENV['QUIET_CLIENT_ID']

  # This could be anything we can invoke with `.call`
  config.process_shipment_handler = ShipQuietLogistics::DummyProcessShipmentHandler
  config.error_message_handler = ShipQuietLogistics::DummyErrorMessageHandler
end

AWS.config(sqs_verify_checksums: false)
