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
                            'OrderDate'   => shipment.order_date) {

              xml.Extension shipment.order.number

              xml.Comments shipment.order.special_instructions

              xml.ShipMode('Carrier'      => shipment.carrier,
                           'ServiceLevel' => shipment.service_level)

              xml.ShipTo(ship_to_hash)
              xml.BillTo(bill_to_hash)

              xml.Notes('NoteType' => shipment['note_type'].to_s,
                        'NoteValue' => shipment['note_value'].to_s)
            }

            shipment.line_items.collect do |item|
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
          'Company'    => shipment.ship_address.company,
          'Contact'    => shipment.full_name,
          'Address1'   => shipment.ship_address.address1,
          'Address2'   => shipment.ship_address.address2,
          'City'       => shipment.ship_address.city,
          'State'      => shipment.ship_address.state.name,
          'PostalCode' => shipment.ship_address.zipcode,
          'Country'    => shipment.ship_address.country.name
        }
      end

      def bill_to_hash
        {
          'Company'    => shipment.bill_address.company,
          'Contact'    => shipment.full_name,
          'Address1'   => shipment.bill_address.address1,
          'Address2'   => shipment.bill_address.address2,
          'City'       => shipment.bill_address.city,
          'State'      => shipment.bill_address.state.name,
          'PostalCode' => shipment.bill_address.zipcode,
          'Country'    => shipment.bill_address.country.name
        }
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
