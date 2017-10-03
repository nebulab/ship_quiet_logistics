module ShipQuietLogistics
  module Documents
    class InventorySummaryResult
      NAMESPACE = 'http://schemas.quietlogistics.com/V2/InventorySummary.xsd'

      attr_reader :type, :io

      def initialize(options = {})
        @io = options[:io]
        @document = Nokogiri::XML::Document.parse(@io)
      end

      def namespace
        @namespace ||= @document.collect_namespaces['xmlns']
      end

      def warehouse
        @document.root.attributes['Warehouse'].value
      end

      def inventories
        @document.root
          .children
          .select {|c| c.name == 'Inventory'}
          .map {|i| Inventory.new(i) }
      end

      class Inventory < SimpleDelegator
        def item_number
          attributes['ItemNumber'].value
        end

        def quantity_available
          children
            .select {|c| c.name == 'ItemStatus' && c.attributes['Status'].value == 'Avail' }
            .first
            .attributes['Quantity'].value
        end
      end
    end
  end
end
