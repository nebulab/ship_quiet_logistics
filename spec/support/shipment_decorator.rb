class ShipmentDecorator < SimpleDelegator
  def bill_address
    order.bill_address
  end

  def carrier
    shipping_method.carrier
  end

  def service_level
    shipping_method.service_level
  end

  def full_name
    ship_address.full_name
  end

  def order_date
    created_at.utc.iso8601
  end

  def ship_address
    address
  end
end
