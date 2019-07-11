module Spree
  module Api
    class SuppliersController < Spree::Api::BaseController
      def index
        if params[:ids]
          @suppliers = Spree::Supplier.accessible_by(current_ability, :read).
            where(id: params[:ids].split(',')).order(:name)
        else
          @suppliers = Spree::Supplier.accessible_by(current_ability, :read).
            order(:name).ransack(params[:q]).result
        end

        @suppliers = paginate(@suppliers)
        respond_with(@suppliers)
      end
    end
  end
end
