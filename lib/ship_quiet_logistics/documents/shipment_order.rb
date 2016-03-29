module ShipQuietLogistics
  module Documents
    class ShipmentOrder
      attr_reader :config, :shipment_number, :shipment, :name

      def initialize(shipment, config)
        @config          = config
        @shipment        = shipment
        @shipment_number = shipment.number
        @name            = "#{@config['business_unit']}_ShipmentOrder_#{@shipment_number}_#{date_stamp}.xml"
      end

      def message
        "Succesfully Sent Shipment #{shipment_number} to Quiet Logistics"
      end

      def to_xml
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.ShipOrderDocument('xmlns' => 'http://schemas.quietlogistics.com/V2/ShipmentOrder.xsd') {

            xml.ClientID config['client_id']
            xml.BusinessUnit config['business_unit']

            xml.OrderHeader('OrderNumber' => shipment_number,
                            'OrderType'   => order_type,
                            'OrderDate'   => shipment.created_at.utc.iso8601) {

              xml.Extension shipment.order.number

              xml.Comments shipment.order.special_instructions

              xml.ShipMode('Carrier'      => shipment['carrier'],
                           'ServiceLevel' => shipment['service_level'])

              xml.ShipTo(ship_to_hash)
              xml.BillTo(bill_to_hash)

              xml.Notes('NoteType' => shipment['note_type'].to_s,
                        'NoteValue' => shipment['note_value'].to_s)
            }

            shipment.order.line_items.collect do |item|
              xml.OrderDetails(line_item_hash(item))
            end
          }
        end

        builder.to_xml
      end

      private

      def line_item_hash(item)
        {
          'ItemNumber'      => item.sku,
          'Line'            => item.id,
          'QuantityOrdered' => item.quantity,
          'QuantityToShip'  => item.quantity,
          'UOM'             => 'EA',
          'Price'           => item.price
        }
      end

      def ship_to_hash
        {
          'Company'    => ship_address.company,
          'Contact'    => full_name,
          'Address1'   => ship_address.address1,
          'Address2'   => ship_address.address2,
          'City'       => ship_address.city,
          'State'      => ship_address.state.name,
          'PostalCode' => ship_address.zipcode,
          'Country'    => ship_address.country.name
        }
      end

      def bill_to_hash
        {
          'Company'    => bill_address.company,
          'Contact'    => full_name,
          'Address1'   => bill_address.address1,
          'Address2'   => bill_address.address2,
          'City'       => bill_address.city,
          'State'      => bill_address.state.name,
          'PostalCode' => bill_address.zipcode,
          'Country'    => bill_address.country.name
        }
      end

      def ship_address
        shipment.address
      end

      def bill_address
        shipment.order.bill_address
      end

      def full_name
        ship_address.full_name
      end

      def date_stamp
        Time.now.strftime('%Y%m%d_%H%M%3N')
      end

      def order_type
        'SO'
      end
    end
  end
end
