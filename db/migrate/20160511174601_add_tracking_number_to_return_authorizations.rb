class AddTrackingNumberToReturnAuthorizations < ActiveRecord::Migration
  def change
    add_column :spree_return_authorizations, :tracking_number, :string, null: true
  end
end
