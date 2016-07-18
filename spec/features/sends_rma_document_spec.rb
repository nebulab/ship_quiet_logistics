require 'spec_helper'

RSpec.describe 'Sending RMA Documents', :vcr do
  let(:rma) { decorate(create(:return_authorization))  }

  it 'sends the document' do
    ShipQuietLogistics.send_rma(rma)

    expect(rma.reload.pushed).to be_truthy
  end

  def decorate(rma)
    RMADecoratorStub.new(rma)
  end

end
