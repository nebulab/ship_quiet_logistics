FactoryGirl.modify do
  factory :shipment, class: Spree::Shipment do
    tracking nil
    state :ready
    association :order, factory: :order_ready_to_ship

    transient do
      sku 'SPREE-T-SHIRT'
    end

    after(:create) do |shipment, evaluator|
      line_item = shipment.line_items.first
      line_item.variant.update(sku: evaluator.sku)

      shipment.address = shipment.order.shipping_address
      shipment.save
    end
  end
end
