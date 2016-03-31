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
          next if !document || document.nil?

          config.process_shipment_handler.(document)
        end
      end

      private

      attr_reader :blackboard, :queue, :config

      def next_message
        queue.receive
      end

      def next_document
        message = next_message

        if error_message?(message)
          handle_error_message(message)
        else
          blackboard.fetch(message)
        end
      end

      def messages_count
        queue.approximate_pending_messages
      end

      def error_message?(message)
        message.instance_of? Gentle::ErrorMessage
      end

      def handle_error_message(message)
        config.error_message_handler.(message)

        nil
      end
    end
  end
end
