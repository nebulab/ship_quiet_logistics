require 'spec_helper'

describe ShipQuietLogistics::EventMessage do
  subject(:xml) do
    described_class.new('ShipmentOrder', 'test.xml', config).to_xml
  end

  let(:config) { Hash.new }

  it 'converts to xml' do
    expect(xml).to match /EventMessage/
  end

  it 'sends message for all warehouses' do
    expect(xml).to match /Warehouse="ALL"/
  end

  context 'with specific warehouse requested' do
    let(:config) { {'warehouse' => 'DV2'} }

    it 'sends message for that warehouse' do
      expect(xml).to match /Warehouse="DV2"/
    end
  end
end
