class AddPushedToSpreeShipment < ActiveRecord::Migration
  def change
    add_column :spree_shipments, :pushed, :boolean, default: false

    Spree::Shipment.shipped.update_all(pushed: true)
  end
end
