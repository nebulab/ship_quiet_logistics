module ShipQuietLogistics
  module Commands
    class SendShipment
      def self.call(shipment)
        new(shipment).call
      end

      def initialize(shipment)
        @shipment = shipment
        @config = ShipQuietLogistics.configuration
      end

      def call
        Api.send_document('ShipmentOrder',
                          shipment,
                          config.outgoing_bucket,
                          config.outgoing_queue,
                          configs)

        shipment.update(pushed: true)
      end

      private

      attr_reader :shipment, :config

      def configs
        {
          'client_id' => config.client_id,
          'business_unit' => config.business_unit
        }
      end
    end
  end
end
