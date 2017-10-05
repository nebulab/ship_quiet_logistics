require_relative './error_handlers/shipment_error_message_handler'
require_relative './error_handlers/inventory_summary_error_message_handler'

module ShipQuietLogistics
  module Handlers
    class ErrorMessageHandler
      def self.call(message)
        case infer_error_type(message.xml.root)
        when :shipment_order
          ShipmentErrorMessageHandler.(message)
        when :inventory_summary
          InventorySummaryErrorMessageHandler.(message)
        else
          GenericErrorMessageHandler.(message)
        end
      end

      def self.infer_error_type(error_node)
        value = error_node.attributes['ResultDescription'].value
        return :generic unless value.present?

        first_line = value.lines.first
        return :generic unless first_line


        if first_line.include?('ShipmentOrder')
          :shipment_order
        elsif first_line.include?('InventorySummary')
          :inventory_summary
        else
          :generic
        end
      end
    end
  end
end
