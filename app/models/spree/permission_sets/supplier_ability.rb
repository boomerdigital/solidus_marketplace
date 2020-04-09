module Spree
  module PermissionSets
    class SupplierAbility < PermissionSets::Base

      def activate!
        can [:admin, :update, :read, :display, :stock], Spree::Product, suppliers: {id: user.supplier_id}
        can [:admin, :create], Spree::Product
        can [:admin, :create, :update, :destroy, :display], Spree::Variant

        can [:admin, :display, :index], Spree::Shipment, order: {state: 'complete'},
            stock_location: {supplier_id: user.supplier_id}

        can [:admin, :display], Spree::ReturnAuthorization, stock_location: {supplier_id: user.supplier_id}
        can [:admin, :display], Spree::CustomerReturn, stock_location: {supplier_id: user.supplier_id}

        #FIXME: come back to these when we work on shipping-related issues
        # can [:admin, :manage, :read, :ready, :ship], Spree::Shipment, order: { state: 'complete' }, stock_location: { supplier_id: user.supplier_id }
        # can [:admin, :create, :update], :stock_items
        can [:admin, :index, :create, :edit, :read, :update], Spree::StockItem, stock_location: {supplier_id: user.supplier_id}
        cannot :display, Spree::StockLocation, active: true
        can [:admin, :manage, :create], Spree::StockLocation, supplier_id: user.supplier_id, active: true
        can [:admin, :manage, :create], Spree::StockMovement, stock_item: {stock_location: {supplier_id: user.supplier_id}}

        can [:admin, :create, :read, :update, :display], Spree::Supplier, id: user.supplier_id
        cannot [:create], Spree::Supplier
        cannot [:index], Spree::Supplier

        can [:display, :admin, :sales_total], :reports

        # can [:admin, :manage],       Spree::User,  supplier_id: user.supplier_id
        can [:admin, :index, :edit, :update], Spree::Order, stock_locations: { supplier_id: user.supplier_id }
        # can [:admin, :index], Spree::Order, supplier_ids: user.supplier_id
        # can [:admin, :edit], Spree::Order, stock_locations: { supplier_id: user.supplier_id }
        can [:admin, :manage, :create], Spree::Image
      end
    end
  end
end