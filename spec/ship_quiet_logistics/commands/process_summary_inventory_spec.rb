require 'spec_helper'

module ShipQuietLogistics
  module Commands
    RSpec.describe Processor do
      let(:blackboard) { spy(:blackboard) }
      let(:queue) { spy(:queue) }
      let(:message) { Gentle::Message.new }

      subject(:process_inventory!) do
        described_class.(blackboard: blackboard, queue: queue)
      end

      context 'with one variant' do
        let!(:variant) { create(:variant) }
        let!(:stock_location) { variant.stock_locations.last }
        let!(:stock_location_name) { stock_location.name }
        let!(:results) { inventory_summary_result(stock_location_name, variant) }

        before { allow(queue).to receive(:approximate_pending_messages) { 2 } }

        it 'processes all the documents' do
          allow(queue).to receive(:receive) { message }

          expect(blackboard).to receive(:fetch)
                                  .and_return(*results)
                                  .exactly(2).times

          process_inventory!

          expect(count_on_hand_for(variant, stock_location_name)).to eq 5
        end
      end

      context 'with an error response' do
        let!(:variant) { create(:variant) }

        let!(:message) { inventory_error_result }

        before { allow(queue).to receive(:approximate_pending_messages) { 1 } }

        it 'processes all the documents' do
          allow(queue).to receive(:receive) { message }
          expect(blackboard).to_not receive(:fetch)

          process_inventory!
        end
      end

      private

      def inventory_summary_result(stock_location_name, variant)
        ShipQuietLogistics::Documents::InventorySummaryResult.new(io:
           %(<?xml version="1.0" encoding="utf-8"?>
          <InventorySummary xmlns="http://schemas.quietlogistics.com/V2/InventorySummary.xsd" ClientId="QUIET" BusinessUnit="QUIET" Warehouse="#{stock_location_name}" >
            <Inventory ItemNumber="#{variant.sku}">
              <ItemStatus Status="Avail" Quantity="5" />
              <ItemStatus Status="RECEIVED" Quantity="1" />
              <ItemStatus Status="Alloc" Quantity="1"/>
            </Inventory>
            <Inventory ItemNumber="12346">
              <ItemStatus Status="Avail" Quantity="2"/>
            </Inventory>
          </InventorySummary>))
      end

      def inventory_error_result
        Gentle::ErrorMessage.new(
          xml: %(<?xml version="1.0" encoding="UTF-8"?>
            <ErrorMessage
              xmlns="http://schemas.quietlogistics.com/V2/EventMessageErrorResponse.xsd"
              OriginalMessageId="ab6e7e7a-6d45-4c75-9fec-e08dba4a9c31"
              ResponseDate="2009-09-01T12:00:00Z"
              ClientId="GENTLE"
              BusinessUnit="GENTLE"
              ResultCode="1030"
              ResultDescription="Document: GENTLE_InventorySummary_WARE1_20160229_135723.xml - Error: An error has occured">
            </ErrorMessage>))
      end

      def count_on_hand_for(variant, stock_location_name)
        stock_item(variant, stock_location_name).count_on_hand
      end

      def stock_item(variant, stock_location_name)
        Spree::StockLocation.find_by_name(stock_location_name).stock_item(variant.id)
      end
    end
  end
end
