require 'spec_helper'

RSpec.describe 'Sending RMA Documents', :vcr do
  let(:rma) { decorate(create(:return_authorization, number: 'RA368041525'))  }

  before do
    allow_any_instance_of(Time).to receive(:strftime).and_return("20160718_1439282")
  end

  it 'sends the document' do
    ShipQuietLogistics.send_rma(rma)

    expect(rma.reload.pushed).to be_truthy
  end

  def decorate(rma)
    RMADecoratorStub.new(rma)
  end

end
