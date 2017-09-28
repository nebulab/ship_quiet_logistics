module ShipQuietLogistics
  module Documents
    class InventorySummary
      attr_reader :config, :name

      def initialize(config)
        @config = config
        @name   = "#{@config['business_unit']}_InventorySummary_#{date_stamp}.xml"
      end

      def message
        "Succesfully Receive Inventory Summary from Quiet Logistics"
      end

      def to_xml
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.InventorySummaryRequest('xmlns' => 'http://schemas.quietlogistics.com/V2/InventorySummaryRequest.xsd') {
            xml.ClientId config['client_id']
            xml.BusinessUnit config['business_unit']
            xml.Wharehouse "ALL"
          }
        end

        builder.to_xml
      end

      def date_stamp
        Time.now.strftime('%Y%m%d_%H%M%3N')
      end
    end
  end
end
