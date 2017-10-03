module ShipQuietLogistics
  module Commands
    class Processor
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
          case document_type document.namespace
            when 'RMADocument'
              config.process_rma_handler.(document)
            when 'SOResultDocument'
              config.process_shipment_handler.(document)
            when 'InventorySummary'
              config.process_inventory_summary_handler.(document)
          end
        end
      end

      protected

      attr_reader :blackboard, :queue, :config

      def document_type(namespace)
        namespace.split('/').last.split('.').first
      end

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
