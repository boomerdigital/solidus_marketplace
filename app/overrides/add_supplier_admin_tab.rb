Deface::Override.new(
  virtual_path: 'spree/admin/shared/_menu',
  name: 'marketplace_menus',
  insert_bottom: "[data-hook='admin_tabs']",
  partial: 'spree/admin/shared/marketplace_tabs'
)
