require 'spec_helper'

module ShipQuietLogistics
  module Documents
    describe ShipmentOrder do
      let(:shipment) { create(:shipment) }

      subject(:document) { described_class.new(shipment, {}) }
      subject(:xml) { Nokogiri::XML(document.to_xml) }

      it 'has the proper name' do
        expect(document.name).to match /^_ShipmentOrder_#{shipment.number}_.*\.xml/
      end

      it 'matches the xml schema' do
        errors = schema.validate xml

        expect(errors).to be_empty
      end

      def schema
        Nokogiri::XML::Schema(File.read('./spec/schemas/shipment_order.xsd'))
      end
    end
  end
end
