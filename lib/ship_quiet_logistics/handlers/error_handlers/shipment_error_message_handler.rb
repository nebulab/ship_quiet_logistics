module ShipQuietLogistics
  module Handlers
    class ShipmentErrorMessageHandler
      def self.call(message)
        shipment = Spree::Shipment.find_by(number: message.shipment_number)

        shipment.update(pushed: false)

        logger.info(message.to_xml)
      end

      def self.logger
        logger = Logger.new('log/fulfillment_event_message_error.log', 'daily')
        logger.level = Logger::INFO
        logger
      end
    end
  end
end
