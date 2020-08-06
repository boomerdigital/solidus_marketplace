# frozen_string_literal: true

module SolidusMarketplace
  module Spree
    module Admin
      module StockLocationsControllerDecorator
        def self.prepended(base)
          base.after_action :set_supplier, only: [:create]
        end

        def index
          @stock_locations = ::Spree::StockLocation.accessible_by(current_ability, :read)
                                                 .order('name ASC')
                                                 .ransack(params[:q])
                                                 .result
                                                 .page(params[:page])
                                                 .per(params[:per_page])
        end
        
        private

        def set_supplier
          if try_spree_current_user.supplier?
            @object.supplier = try_spree_current_user.supplier
            @object.save
          end
        end

        ::Spree::Admin::StockLocationsController.prepend self
      end
    end
  end
end
