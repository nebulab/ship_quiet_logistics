module ShipQuietLogistics
  module Handlers
    class ProcessShipmentHandler
      def self.call(document)
        shipment = Spree::Shipment.find_by(number: document.order_number)

        shipment.ship!
        shipment.update(tracking: document.tracking_number)
      end
    end
  end
end
