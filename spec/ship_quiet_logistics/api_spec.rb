require 'spec_helper'

describe ShipQuietLogistics::Api do
  before do
    ShipQuietLogistics::Uploader.any_instance.stub(:process)
    ShipQuietLogistics::Sender.any_instance.stub(:send_message)
  end

  it 'sends shipment order transfer to QL' do
    message = described_class.send_document('ShipmentOrder', Factories.shipment, 'test', 'test', {})
    expect(message).to eq 'Succesfully Sent Shipment 12836 to Quiet Logistics'
  end

  it 'sends rma doc to QL' do
    message = described_class.send_document('RMADocument', Factories.shipment, 'test', 'test', {})

    expect(message).to eq 'Sent RMA 12836 to QL'
  end

  xit 'send purchase order to QL' do
    # TODO: Look into unpending this test or getting rid of it
    message =  described_class.send_document('PurchaseOrder', Factories.purchase_order, 'test', 'test', {})
    expect(message[:messages].first[:message]).to eq 'purchase_order:transmit'
  end

  xit 'sends item profile document/message to QL' do
    # TODO: Look into unpending this test or getting rid of it
    message = described_class.send_document('ItemProfile', Factories.item, 'test', 'test', {})
    expect(message[:messages].first[:message]).to eq 'purchase_order:transmit'
  end

  xit 'sends purchase order transfer to QL' do
    # TODO: Look into unpending this test or getting rid of it
    message = described_class.send_document('PurchaseOrder', Factories.to_purchase_order, 'test', 'test', {})
    message[:messages].first[:message].should eq 'purchase_order:transmit'
  end
end
