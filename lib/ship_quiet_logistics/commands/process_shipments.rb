module ShipQuietLogistics
  module Commands
    class ProcessShipments
      def self.call
        new.call
      end

      def initialize
        @config = ShipQuietLogistics.configuration
      end

      def call
        receiver = Receiver.new(queue)
        receiver.receive_messages do |message|
          content = Processor.new(bucket).process_doc(message)
        end

        # do something with the content
      end

      private

      attr_reader :config

      def queue
        config.incoming_queue
      end

      def bucket
        config.incoming_bucket
      end
    end
  end
end
