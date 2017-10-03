require 'spec_helper'

RSpec.describe 'Receive Inventory Summary', :vcr do

  before do
    allow_any_instance_of(
      ShipQuietLogistics::Documents::InventorySummary
    ).to receive(:date_stamp) { '20170928_1439282' }
  end

  it 'receives the results' do
    res = ShipQuietLogistics.receive_inventory_summary
    expect(res).to eq "Successfully Received Inventory Summary from Quiet Logistics"
  end
end
