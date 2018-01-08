require 'spec_helper'

module ShipQuietLogistics
  module Documents
    describe InventorySummaryRequest do
      subject(:document) { described_class.new(config) }
      subject(:xml) { Nokogiri::XML(document.to_xml) }

      let(:config) do
        {
          'client_id' => 'QUIET',
          'business_unit' => 'QUIET',
          'warehouse' => 'ALL'
        }
      end

      it 'has the proper name' do
        expect(document.name).to match /^QUIET_InventorySummaryRequest_ALL_.*\.xml/
      end

      it 'matches the xml schema' do
        pending 'Fix Wharehouse not allowed'
        errors = schema.validate xml
        expect(errors).to be_empty
      end

      def schema
        Nokogiri::XML::Schema(File.read('./spec/schemas/inventory_summary_request.xsd'))
      end
    end
  end
end
