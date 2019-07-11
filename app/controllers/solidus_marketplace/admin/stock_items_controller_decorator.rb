module SolidusMarketplace
  module Admin
    module StockItemsControllerDecorator
      extend ActiveSupport::Concern

      included do
        prepend(InstanceMethods)
        before_action :load_supplier_stock_location, only: :index
      end

      module InstanceMethods
        def load_supplier_stock_location
          if try_spree_current_user.supplier
            @stock_locations = Spree::StockLocation.by_supplier(try_spree_current_user.supplier).accessible_by(current_ability, :read)
            @stock_item_stock_locations = params[:stock_location_id].present? ? @stock_locations.where(id: params[:stock_location_id]) : @stock_locations
          end
        end
      end
    end
  end
end
