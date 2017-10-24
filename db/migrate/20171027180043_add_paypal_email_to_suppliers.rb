class AddPaypalEmailToSuppliers < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_suppliers, :paypal_email, :string
  end
end
