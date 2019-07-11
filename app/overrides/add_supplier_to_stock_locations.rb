Deface::Override.new(
  virtual_path: 'spree/admin/stock_locations/_form',
  name: 'add_supplier_to_stock_locations_form',
  insert_bottom: '[data-hook="admin_stock_locations_form_fields"]',
  partial: 'spree/admin/shared/supplier_stock_location_form',
  disabled: false,
)
