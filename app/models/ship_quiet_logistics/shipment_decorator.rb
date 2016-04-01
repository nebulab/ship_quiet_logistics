module ShipQuietLogistics
  module ShipmentDecorator
    def self.prepended(base)
      class << base
        def not_pushed
          where(pushed: false)
        end
      end
    end
  end
end

::Spree::Shipment.prepend ShipQuietLogistics::ShipmentDecorator
