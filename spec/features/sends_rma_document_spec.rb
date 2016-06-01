require 'spec_helper'

RSpec.describe 'Sending RMA Documents', :vcr do
  let(:rma) { create(:return_authorization)  }

  it 'sends the document' do
    ShipQuietLogistics.send_rma(rma)

    expect(rma.reload.pushed).to be_truthy
  end
end
