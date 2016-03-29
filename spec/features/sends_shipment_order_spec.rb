require 'spec_helper'

RSpec.describe 'Sending shipment orders', :vcr do
  let(:shipment) { create(:shipment, number: 'H15535307815') }

  before do
    Timecop.freeze 2016, 3, 29, 14, 14
  end

  it 'sends the shipment' do
    ShipQuietLogistics.send_shipment(shipment)
  end
end
