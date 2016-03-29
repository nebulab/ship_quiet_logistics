require 'spec_helper'

RSpec.describe 'Sending shipment orders', :vcr do
  let(:shipment) { create(:shipment, number: 'H15535307815') }

  before do
    Timecop.freeze 'Tue, 29 Mar 2016 05:23:34 UTC +00:00'
  end

  it 'sends the shipment' do
    ShipQuietLogistics.send_shipment(shipment)
  end
end
