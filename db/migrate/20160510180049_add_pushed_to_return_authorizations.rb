class AddPushedToReturnAuthorizations < ActiveRecord::Migration
  def change
    add_column :spree_return_authorizations, :pushed, :boolean, default: false

    Spree::ReturnAuthorization.update_all(pushed: true)
  end
end
