module Spree
  class SupplierAbility
    include CanCan::Ability

    def initialize(user)
      user ||= Spree.user_class.new

      if user.supplier_admin?
        can [:admin, :update, :read, :display, :stock],     Spree::Product, suppliers: { id: user.supplier_id }
        can [:admin, :create],                              Spree::Product
				can [:admin, :create, :update, :destroy, :display], Spree::Variant, suppliers: { id: user.supplier_id }

        can [:admin, :display, :index], Spree::Shipment, order: { state: 'complete' },
                                                 stock_location: { supplier_id: user.supplier_id }

        can [:admin, :display], Spree::ReturnAuthorization, stock_location: { supplier_id: user.supplier_id }
        can [:admin, :display], Spree::CustomerReturn,      stock_location: { supplier_id: user.supplier_id }

        #FIXME: come back to these when we work on shipping-related issues
        # can [:admin, :manage, :read, :ready, :ship], Spree::Shipment, order: { state: 'complete' }, stock_location: { supplier_id: user.supplier_id }
        # can [:admin, :create, :update], :stock_items
        can [:admin, :index, :create, :edit, :read, :update],  Spree::StockItem,     stock_location: { supplier_id: user.supplier_id }
        can [:admin, :manage, :create],        Spree::StockLocation, supplier_id: user.supplier_id
        can [:admin, :manage, :create],        Spree::StockMovement, stock_item: { stock_location: { supplier_id: user.supplier_id } }

        can [:admin, :create, :read, :update, :display], Spree::Supplier, id: user.supplier_id
        cannot [:create],                                Spree::Supplier

        can [:admin, :manage],       Spree::User,  supplier_id: user.supplier_id
        can [:admin, :index, :edit], Spree::Order, stock_locations: { supplier_id: user.supplier_id }
      end

    end
  end
end
