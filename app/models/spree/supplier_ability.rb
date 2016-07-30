module Spree
  class SupplierAbility
    include CanCan::Ability

    def initialize(user)
      user ||= Spree.user_class.new

      if user.supplier
        # Does not work inline due to ransack applied on collections in admin controller
        # can [:admin, :stock, :manage, :index], Spree::Product, suppliers: { id: user.supplier_id }
        can [:admin, :read, :stock], Spree::Product, supplier_ids: user.supplier_id
        can [:manage], Spree::Product do |product|
          product.supplier_ids.include?(user.supplier_id)
        end
        # can [:admin, :create, :index], Spree::Product
        can [:admin, :read], Spree::Variant
        can [:admin, :manage, :read, :ready, :ship], Spree::Shipment, order: { state: 'complete' }, stock_location: { supplier_id: user.supplier_id }
        can [:admin, :create, :update], :stock_items
        can [:admin, :manage], Spree::StockItem, stock_location_id: user.supplier.stock_locations.pluck(:id)
        can [:admin, :create], Spree::StockLocation
        cannot :read, Spree::StockLocation
        can [:read, :manage], Spree::StockLocation, supplier_id: user.supplier_id
        can [:admin, :manage], Spree::StockMovement, stock_item: { stock_location_id: user.supplier.stock_locations.pluck(:id) }
        can :create, Spree::StockMovement
        can [:admin, :update], Spree::Supplier, id: user.supplier_id
      end

    end
  end
end
