module Spree
  class SupplierAbility
    include CanCan::Ability

    def initialize(user)
      user ||= Spree.user_class.new

      if user.supplier_admin?
        can [:admin, :create, :read, :update, :destroy, :stock], Spree::Product, id: user.supplier.products.pluck(:id)
        can [:admin, :create, :read, :update, :destroy],         Spree::Variant, id: user.supplier.variants.pluck(:id)

        can [:admin, :read], Spree::Shipment, order: { state: 'complete' }, stock_location: { supplier_id: user.supplier_id }

        #FIXME: come back to these when we work on shipping-related issues
        # can [:admin, :manage, :read, :ready, :ship], Spree::Shipment, order: { state: 'complete' }, stock_location: { supplier_id: user.supplier_id }
        can [:admin, :manage, :create], Spree::StockItem,     stock_location_id: user.supplier.stock_locations.pluck(:id)
        can [:admin, :index, :show, :new, :edit, :create, :update], Spree::StockLocation, supplier_id: user.supplier_id
        can [:admin, :manage, :create], Spree::StockMovement, stock_item: { stock_location_id: user.supplier.stock_locations.pluck(:id) }

        # cannot :read, Spree::StockLocation
        # can [:read, :manage], Spree::StockLocation, supplier_id: user.supplier_id
        can [:admin, :manage], Spree::Supplier, id: user.supplier_id
        can [:admin, :manage], Spree::User, supplier_id: user.supplier_id
        can [:admin, :read],            Spree::Order,    stock_location: { supplier_id: user.supplier_id }
      end

    end
  end
end
