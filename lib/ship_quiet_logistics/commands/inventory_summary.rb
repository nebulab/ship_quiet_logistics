module ShipQuietLogistics
  module Commands
    class InventorySummary
      def self.call()
        new().call
      end

      def initialize
        @config = ShipQuietLogistics.configuration
      end

      def call
        Api.send_document('InventorySummary',
                          nil,
                          config.outgoing_bucket,
                          config.outgoing_queue,
                          configs)

      end

      private

      attr_reader :config

      def configs
        {
          'client_id' => config.client_id,
          'business_unit' => config.business_unit
        }
      end
    end
  end
end
