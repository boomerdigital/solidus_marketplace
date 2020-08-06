module Spree
  module Admin
    class SuppliersController < Spree::Admin::ResourceController
      before_action :set_address, only: [:update]
      before_action :build_address, only: [:edit, :new]

      private

      def set_address
        @object.address = Spree::Address.immutable_merge(@object.address,
                                                         permitted_resource_params.delete(:address_attributes))
      end

      def build_address
        @object.address = Spree::Address.build_default unless @object.address.present?
      end

      def collection
        params[:q] ||= {}
        @search = Spree::Supplier.search(params[:q])
        @collection = @search.result.includes(:admins).page(params[:page]).
          per(Spree::Config[:orders_per_page])
      end

      def find_resource
        Spree::Supplier.friendly.find(params[:id])
      end

      def location_after_save
        spree.edit_admin_supplier_path(@object)
      end
    end
  end
end
