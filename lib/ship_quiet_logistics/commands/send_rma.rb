module ShipQuietLogistics
  module Commands
    class SendRma
      def self.call(rma)
        new(rma).call
      end

      def initialize(rma)
        @rma = rma
        @config = ShipQuietLogistics.configuration
      end

      def call
        Api.send_document('RMADocument',
                          rma,
                          config.outgoing_bucket,
                          config.outgoing_queue,
                          configs)

        rma.update(pushed: true)
      end

      private

      attr_reader :rma, :config

      def configs
        {
            'client_id' => config.client_id,
            'business_unit' => config.business_unit
        }
      end
    end
  end
end
