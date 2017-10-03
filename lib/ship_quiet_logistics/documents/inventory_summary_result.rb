module ShipQuietLogistics
  module Documents
    class InventorySummaryResult
      NAMESPACE = 'http://schemas.quietlogistics.com/V2/InventorySummary.xsd'

      attr_reader :type, :io

      def initialize(options = {})
        @io = options[:io]
        @document = Nokogiri::XML::Document.parse(@io)
      end

      def to_h
        {
          warehouse: @warehouse,
        }
      end

      def namespace
        @namespace ||= @document.collect_namespaces['xmlns']
      end
    end
  end
end
