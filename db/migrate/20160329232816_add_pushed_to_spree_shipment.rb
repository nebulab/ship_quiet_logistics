class AddPushedToSpreeShipment < ActiveRecord::Migration
  def change
    add_column :spree_shipments, :pushed, :boolean
  end
end
