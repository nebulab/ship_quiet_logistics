module ShipQuietLogistics
  module ReturnAuthorizationDecorator
    def self.prepended(base)
      attr_accessor :tracking
      class << base
        def not_pushed
          where(pushed: false)
        end
      end
    end
  end
end

::Spree::ReturnAuthorization.prepend ShipQuietLogistics::ReturnAuthorizationDecorator
