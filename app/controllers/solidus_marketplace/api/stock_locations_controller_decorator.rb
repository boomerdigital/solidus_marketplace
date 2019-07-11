module SolidusMarketplace
  module Api
    module StockLocationsControllerDecorator
      extend ActiveSupport::Concern

      included do
        prepend(InstanceMethods)
        before_action :supplier_locations, only: [:index]
        before_action :supplier_transfers, only: [:index]
      end

      module InstanceMethods
        private

        def supplier_locations
          params[:q] ||= {}
          params[:q][:supplier_id_eq] = spree_current_user.supplier_id
        end

        def supplier_transfers
          params[:q] ||= {}
          params[:q][:supplier_id_eq] = spree_current_user.supplier_id
        end
      end
    end
  end
end
