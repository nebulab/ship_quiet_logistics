require 'spec_helper'

describe ShipQuietLogistics do
  it 'has a version number' do
    expect(ShipQuietLogistics::VERSION).not_to be nil
  end

  context 'sending a shipment' do
    let(:shipment) { double(:shipment) }
    let(:command) { ShipQuietLogistics::Commands::SendShipment }

    subject(:send_shipment!) { described_class.send_shipment(shipment) }

    it 'sends the shipment' do
      expect(command).to receive(:call).with shipment

      send_shipment!
    end
  end

  context 'getting a shipments result' do
    let(:shipment) { double(:shipment) }
    let(:command) { ShipQuietLogistics::Commands::Processor }

    subject(:process_shipments!) { described_class.process_shipments }

    it 'processes the shipments' do
      expect(command).to receive(:call)

      process_shipments!
    end
  end
end
