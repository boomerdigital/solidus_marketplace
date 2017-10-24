Deface::Override.new(
  virtual_path: "spree/admin/shared/_menu",
  name: "marketplace_menus",
  insert_bottom: '[data-hook="admin_tabs"]',
  partial: "spree/admin/shared/marketplace_tabs"
)


Deface::Override.new(
  virtual_path: "spree/admin/shared/_configuration_menu",
  name: "marketplace_admin_configurations_menu",
  insert_bottom: "[data-hook='admin_configurations_sidebar_menu']",
  disabled: false,
  partial: "spree/admin/shared/marketplace_settings"
)
