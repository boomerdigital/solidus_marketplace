Deface::Override.new(
  virtual_path: "spree/admin/shipments/index",
  name: "add_supplier_to_admin_shipments",
  insert_before: '[data-hook="admin_shipments_index_header_actions"]',
  text: "<th><%= sort_link @search, :supplier_commission,  Spree::Shipment.human_attribute_name(:supplier_commission) %></th>",
  disabled: false
)
Deface::Override.new(
    virtual_path: "spree/admin/shipments/index",
    name: "add_supplier_to_admin_shipments2",
    insert_before: '[data-hook="admin_shipments_index_row_actions"]',
    text: "<td><%= Spree::Money.new(shipment.supplier_commission, currency: shipment.currency).to_html %></td>",
    disabled: false
)

Deface::Override.new(
    virtual_path: "spree/admin/shipments/edit",
    name: "add_supplier_to_admin_shipments3",
    insert_before: '[data-hook="admin_shipment_form_fields"]',
    text: "<% if spree_current_user.admin? && @shipment.supplier.present? %>
            <div data-hook='admin_shipment_supplier' class='row'>
              <fieldset class='col-md-12 no-border-bottom'>
                <legend align='center'><%= Spree.t(:supplier_information) %></legend>
                <div>
                  <b><%= Spree::Supplier.human_attribute_name(:name) %>:</b> <%= @shipment.supplier.name %><br/>
                  <b><%= Spree::Supplier.human_attribute_name(:email) %>:</b> <%= @shipment.supplier.user.email %><br/>
                  <b><%= Spree::Supplier.human_attribute_name(:url) %>:</b> <%= link_to @shipment.supplier.url, @shipment.supplier.url if @shipment.supplier.url.present? %><br/>
                </div>
                <div>
                  <b><%= Spree.t('contact_information') %>:</b>
                </div>
                <%= render partial: 'spree/shared/address', locals: { address: @shipment.supplier.address } %>
              </fieldset>
            </div>
          <% end %>",
    disabled: false
)

