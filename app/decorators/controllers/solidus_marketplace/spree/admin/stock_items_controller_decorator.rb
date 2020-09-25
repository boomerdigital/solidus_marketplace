# frozen_string_literal: true

module SolidusMarketplace
  module Spree
    module Admin
      module StockItemsControllerDecorator
        def self.prepended(base)
          base.before_action :load_supplier_stock_location, only: :index
        end

        def load_supplier_stock_location
          if try_spree_current_user.supplier
            @stock_locations = ::Spree::StockLocation.by_supplier(try_spree_current_user.supplier).accessible_by(current_ability, :read)
            @stock_item_stock_locations = params[:stock_location_id].present? ? @stock_locations.where(id: params[:stock_location_id]) : @stock_locations
          end
        end

        def variant_scope
          scope = super
          if try_spree_current_user.supplier
            scope = scope.joins(:stock_locations).where(spree_stock_locations: {supplier_id: spree_current_user.supplier.id})
          end
          scope
        end

        ::Spree::Admin::StockItemsController.prepend self
      end
    end
  end
end
