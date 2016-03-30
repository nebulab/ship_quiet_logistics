require 'spec_helper'

RSpec.describe 'Receiving shipments results', :vcr do
  let!(:shipment) { create(:shipment, number: 'H11111111111') }

  subject { shipment.reload }

  it 'receives the results' do
    ShipQuietLogistics.process_shipments

    expect(subject).to be_shipped
    expect(subject.tracking).to eq '1Z1006639560001'
  end
end
