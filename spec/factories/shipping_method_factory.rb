FactoryGirl.modify do
  factory :base_shipping_method, class: Spree::ShippingMethod do
    carrier 'USPS'
    service_level 'FIRST'
  end
end
