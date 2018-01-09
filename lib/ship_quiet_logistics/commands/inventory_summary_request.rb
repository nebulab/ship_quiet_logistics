module ShipQuietLogistics
  module Commands
    class InventorySummaryRequest
      def self.call(warehouse_name)
        new(warehouse_name).call
      end

      def initialize(warehouse_name)
        @config = ShipQuietLogistics.configuration
        @warehouse_name = warehouse_name
      end

      def call
        Api.send_document('InventorySummaryRequest',
                          nil,
                          config.outgoing_bucket,
                          config.outgoing_queue,
                          configs)
      end

      private

      attr_reader :config, :warehouse_name

      def configs
        {
          'client_id' => config.client_id,
          'business_unit' => config.business_unit,
          'warehouse' => warehouse_name
        }
      end
    end
  end
end
