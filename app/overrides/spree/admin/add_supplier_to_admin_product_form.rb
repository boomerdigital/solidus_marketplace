Deface::Override.new(
  virtual_path: 'spree/admin/products/_form',
  name: 'add_supplier_input_to_product_form',
  insert_before: "[data-hook='admin_product_form_taxons']",
  partial: 'spree/admin/shared/supplier_product_form',
  disabled: false,
)
