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

          # we need to handle an error response
          config.process_shipment.(document)
        end
      end

      private

      attr_reader :blackboard, :queue, :config

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
