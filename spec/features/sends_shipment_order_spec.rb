require 'spec_helper'

RSpec.describe 'Sending shipment orders', :vcr do
  let(:shipment) { create(:shipment) }

  it 'sends the shipment' do
    ShipQuietLogistics.send_shipment(shipment)
  end
end
