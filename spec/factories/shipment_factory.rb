FactoryGirl.modify do
  factory :shipment, class: Spree::Shipment do
    tracking nil
    state :ready
    association :order, factory: :order_ready_to_ship

    after(:create) do |shipment, _|
      shipment.address = shipment.order.shipping_address
      shipment.save
    end
  end
end
