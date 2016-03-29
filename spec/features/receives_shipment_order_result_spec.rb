require 'spec_helper'

RSpec.describe 'Receiving shipments results', :vcr do
  let(:shipment) { create(:shipment, number: 'H15535307815') }

  it 'receives the results' do
    ShipQuietLogistics.process_shipments
  end
end
