require 'spec_helper'

RSpec.describe 'Receive Inventory Summary', :vcr do

  before do
    allow_any_instance_of(
      ShipQuietLogistics::Documents::InventorySummaryRequest
    ).to receive(:date_stamp) { '20170928_1439282' }
  end

  it 'receives the results' do
    res = ShipQuietLogistics.request_inventory_summary('WarehouseCode')
    expect(res).to eq "Successfully sent InventorySummaryRequest to Quiet Logistics"
  end
end
