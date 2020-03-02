Deface::Override.new(
  virtual_path: "spree/admin/orders/index",
  name: "add_supplier_to_admin_orders",
  insert_before: '[data-hook="admin_orders_index_row_actions"]',
  text: "<td class='align-center'>
          <% if try_spree_current_user.supplier? %>
            <%= order.supplier_total(try_spree_current_user).to_html %>
          <% else %>
            <%= order.display_total.to_html %>
          <% end %>
        </td>",
  disabled: false

)
