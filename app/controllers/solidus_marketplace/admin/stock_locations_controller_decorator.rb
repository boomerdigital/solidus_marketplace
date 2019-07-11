module SolidusMarketplace
  module Admin
    module StockLocationsControllerDecorator
      extend ActiveSupport::Concern

      included do
        prepend(InstanceMethods)
        create.after :set_supplier

        def index
          @stock_locations = Spree::StockLocation.accessible_by(current_ability, :read)
                                                 .order('name ASC')
                                                 .ransack(params[:q])
                                                 .result
                                                 .page(params[:page])
                                                 .per(params[:per_page])
        end
      end

      module InstanceMethods
        private

        def set_supplier
          if try_spree_current_user.supplier?
            @object.supplier = try_spree_current_user.supplier
            @object.save
          end
        end
      end
    end
  end
end
