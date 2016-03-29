module ShipQuietLogistics
  module Commands
    class ProcessShipments
      def self.call(blackboard:, queue:)
        new(blackboard, queue).()
      end

      def initialize(blackboard, queue)
        @blackboard = blackboard
        @queue = queue

        @config = ShipQuietLogistics.configuration
      end

      def call
        messages_count.times do
          document = next_document
          next if document.nil?

          update_shipment(document)
        end
      end

      private

      attr_reader :blackboard, :queue, :config

      def update_shipment(document)
        shipment = find_shipment(document)

        shipment.ship!
        shipment.update(tracking: document.tracking_number)
      end

      def find_shipment(document)
        Spree::Shipment.find_by(number: document.order_number)
      end

      def next_message
        queue.receive
      end

      def next_document
        blackboard.fetch(next_message)
      end

      def messages_count
        queue.approximate_pending_messages
      end
    end
  end
end
