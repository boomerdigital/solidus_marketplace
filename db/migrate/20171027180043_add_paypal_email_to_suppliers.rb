# frozen_string_literal: true

class AddPaypalEmailToSuppliers < SolidusSupport::Migration[5.1]
  def change
    add_column :spree_suppliers, :paypal_email, :string
  end
end
