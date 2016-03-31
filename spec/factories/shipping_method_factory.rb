FactoryGirl.modify do
  factory :base_shipping_method, class: Spree::ShippingMethod do
    carrier 'UPS'
    service_level 'GROUND'
  end
end
