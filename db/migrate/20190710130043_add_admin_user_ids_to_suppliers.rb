# frozen_string_literal: true

class AddAdminUserIdsToSuppliers < SolidusSupport::Migration[5.1]
  def change
    add_column :spree_suppliers, :admin_id, :integer
    add_index :spree_suppliers, :admin_id
  end
end
