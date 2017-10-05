module ShipQuietLogistics
  module Handlers
    class GenericErrorMessageHandler
      def self.call(message)
        logger.info(message.to_xml)
      end

      def self.logger
        logger = Logger.new('log/generic_event_message_error.log', 'daily')
        logger.level = Logger::INFO
        logger
      end
    end
  end
end
