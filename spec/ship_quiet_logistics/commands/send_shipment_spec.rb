require 'spec_helper'

module ShipQuietLogistics
  module Commands
    describe SendShipment do
      describe '.call' do
        let(:shipment) { double(:shipment) }
        let(:api) { ShipQuietLogistics::Api }

        subject(:send_shipment!) { described_class.call(shipment) }

        let(:params) do
          [
            'ShipmentOrder',
            shipment,
            ENV['QUIET_OUTGOING_BUCKET'],
            ENV['QUIET_OUTGOING_QUEUE'],
            {
              'client_id' => ENV['QUIET_CLIENT_ID'],
              'business_unit' => ENV['QUIET_BUSINESS_UNIT']
            }
          ]

        end

        it 'calls into the api with shipment' do
          expect(api).to receive('send_document').with *params

          send_shipment!
        end
      end
    end
  end
end
