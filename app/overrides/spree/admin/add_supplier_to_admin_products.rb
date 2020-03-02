Deface::Override.new(
  virtual_path: "spree/admin/products/_form",
  name: "add_supplier_to_admin_products",
  insert_before: '[data-hook="admin_product_form_taxons"]',
  text: "<% if try_spree_current_user.market_maker? %>
            <div data-hook='admin_product_form_suppliers'>
              <%= f.field_container :suppliers do %>
                <%= f.label :supplier_ids, plural_resource_name(Spree::Supplier) %><br />
                <%= f.hidden_field :supplier_ids, value: @product.supplier_ids.join(',') %>
              <% end %>
            </div>
          <% end %>",
  disabled: false

)
