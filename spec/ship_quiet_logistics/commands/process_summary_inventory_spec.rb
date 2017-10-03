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

      context 'with many variants' do
        let!(:variants) { create_list(:variant, 2) }

        let!(:results) do
          variants.map { |v| inventory_summary_result(v) }
        end

        before { allow(queue).to receive(:approximate_pending_messages) { 2 } }

        it 'processes all the documents' do
          allow(queue).to receive(:receive) { message }

          expect(blackboard).to receive(:fetch)
                                  .and_return(*results)
                                  .exactly(2).times

          process_inventory!
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

      def inventory_summary_result(variant)
        ShipQuietLogistics::Documents::InventorySummaryResult.new(io:
           %(<?xml version="1.0" encoding="utf-8"?>
          <InventorySummary xmlns="http://schemas.quietlogistics.com/V2/InventorySummary.xsd" ClientId="QUIET" BusinessUnit="QUIET" Warehouse="CORP1" >
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
              ResultDescription="Document: Gentle_Inventory_Summary_20160229_135723.xml - Error: An error has occured">
            </ErrorMessage>))
      end
    end
  end
end
