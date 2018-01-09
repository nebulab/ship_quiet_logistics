module ShipQuietLogistics
  module Documents
    class InventorySummaryRequest
      attr_reader :config, :name

      def initialize(config)
        @config = config
        @name   = "#{@config['business_unit']}_InventorySummaryRequest_#{config['warehouse']}_#{date_stamp}.xml"
      end

      def message
        "Successfully sent InventorySummaryRequest to Quiet Logistics"
      end

      def to_xml
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.InventorySummaryRequest('xmlns' => 'http://schemas.quietlogistics.com/V2/InventorySummaryRequest.xsd',
            'ClientId' => config['client_id'],
            'BusinessUnit' => config['business_unit'],
            'Warehouse' => config['warehouse']
          )
        end

        builder.to_xml
      end

      def date_stamp
        Time.now.strftime('%Y%m%d_%H%M%3N')
      end
    end
  end
end
