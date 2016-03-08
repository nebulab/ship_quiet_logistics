require 'spec_helper'

describe ShipQuietLogistics::EventMessage do
  subject(:xml) do
    described_class.new('ShipmentOrder', 'test.xml', '').to_xml
  end

  it 'converts to xml' do
    expect(xml).to match /EventMessage/
  end
end
