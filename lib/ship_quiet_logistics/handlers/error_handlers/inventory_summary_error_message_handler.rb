module ShipQuietLogistics
  module Handlers
    class InventorySummaryErrorMessageHandler
      def self.call(message)
        logger.info(message.to_xml)
      end

      def self.logger
        logger = Logger.new('log/inventory_summary_event_message_error.log', 'daily')
        logger.level = Logger::INFO
        logger
      end
    end
  end
end
