Deface::Override.new(
  virtual_path: "spree/admin/users/_tabs",
  name: "add_payment_data_to_admin_user",
  insert_bottom: '[data-hook="admin_user_tab_options"]',
  partial: "spree/admin/shared/payment_data_user",
  disabled: false

)
