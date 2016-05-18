require 'spec_helper'

module ShipQuietLogistics
  module Commands
    RSpec.describe Processor do
      let(:blackboard) { spy(:blackboard) }
      let(:queue) { spy(:queue) }
      let(:message) { Gentle::Message.new }

      subject(:process_shipments!) do
        described_class.(blackboard: blackboard, queue: queue)
      end

      context 'with one shipment' do
        let!(:shipment) { create(:shipment) }

        let!(:result) { shipment_order_result(shipment) }

        before { allow(queue).to receive(:approximate_pending_messages) { 1 } }

        it 'updates the shipment to shipped' do
          expect(queue).to receive(:receive) { message }
          expect(blackboard).to receive(:fetch) { result }

          process_shipments!

          expect(shipment.reload).to have_attributes \
            state: 'shipped', tracking: 'a-tracking-number'
        end
      end

      context 'with many shipments' do
        let!(:shipments) { create_list(:shipment, 2) }

        let!(:results) do
          shipments.map { |s| shipment_order_result(s) }
        end

        before { allow(queue).to receive(:approximate_pending_messages) { 2 } }

        it 'processes all the documents' do
          allow(queue).to receive(:receive) { message }

          expect(blackboard).to receive(:fetch)
                                  .and_return(*results)
                                  .exactly(2).times

          process_shipments!
        end
      end

      context 'with an error response' do
        let!(:shipment) { create(:shipment) }

        let!(:message) { shipment_error_result(shipment) }

        before { allow(queue).to receive(:approximate_pending_messages) { 1 } }

        it 'processes all the documents' do
          allow(queue).to receive(:receive) { message }
          expect(blackboard).to_not receive(:fetch)

          process_shipments!
        end

      end

      def shipment_order_result(shipment)
        Gentle::Documents::Response::ShipmentOrderResult.new(
        io: %(<?xml version="1.0" encoding="utf-8"?>
              <SOResult xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" ClientID="ADAY" BusinessUnit="ADAY" OrderNumber="#{shipment.number}" DateShipped="2016-03-30T17:20:21.9964321Z" FreightCost="0" CartonCount="1" Warehouse="dvn" xmlns="http://schemas.quiettechnology.com/V2/SOResultDocument.xsd">
                <Line Line="1" ItemNumber="SPREE-T-SHIRT" Quantity="1" ExceptionCode="" Tax="0" Total="0" SubstitutedItem="" />
                <Line Line="2" ItemNumber="SPREE-SHIRT" Quantity="1" ExceptionCode="" Tax="0" Total="0" SubstitutedItem="" />
                <Carton CartonId="S99H11111111111-1" TrackingId="a-tracking-number"" Carrier="UPS" CartonNumber="1" ServiceLevel="GROUND" Weight="1.2" FreightCost="3.05" HandlingFee="0" Surcharge="0">
                  <Content Line="1" ItemNumber="SPREE-T-SHIRT" Quantity="1" />
                  <Content Line="2" ItemNumber="SPREE-SHIRT" Quantity="1" />
                </Carton>
                <Extension>R762997806</Extension>
              </SOResult>))
      end

      def shipment_error_result(shipment)
        Gentle::ErrorMessage.new(
          xml: %(<?xml version="1.0" encoding="UTF-8"?>
            <ErrorMessage
              xmlns="http://schemas.quietlogistics.com/V2/EventMessageErrorResponse.xsd"
              OriginalMessageId="ab6e7e7a-6d45-4c75-9fec-e08dba4a9c31"
              ResponseDate="2009-09-01T12:00:00Z"
              ClientId="GENTLE"
              BusinessUnit="GENTLE"
              ResultCode="1030"
              ResultDescription="Document: Gentle_ShipmentOrder_#{shipment.number}_20160229_135723.xml - Error: An error has occured">
            </ErrorMessage>))
      end
    end
  end
end
