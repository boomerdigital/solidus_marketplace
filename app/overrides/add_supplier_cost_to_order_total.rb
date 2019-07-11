Deface::Override.new(
  virtual_path: 'spree/admin/orders/index',
  name: 'add_supplier_input_to_product_form',
  replace_contents: "[data-hook='admin_orders_index_rows'] td:nth-child(9)",
  partial: 'spree/admin/shared/supplier_order_total',
  disabled: false,
)
