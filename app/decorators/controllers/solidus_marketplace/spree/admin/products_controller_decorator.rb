# frozen_string_literal: true

module SolidusMarketplace
  module Spree
    module Admin
      module ProductsControllerDecorator
        def self.prepended(base)
          base.before_action :get_suppliers, only: [:edit] #, :update]
          base.before_action :supplier_collection, only: [:index]
          base.after_action :update_product_suppliers, only: [:update], unless: -> { params['product']['supplier_ids'].nil? }
          base.after_action :add_product_to_supplier, only: [:create]
        end

        private

        def permitted_resource_params
          params[object_name].present? ? params.require(object_name).permit! : ActionController::Parameters.new.permit!
          params[object_name].except(:supplier_ids)
        end

        def update_product_suppliers
          if adding_suppliers?
            supplier_ids = new_supplier_ids - current_supplier_ids
            @product.add_suppliers!(supplier_ids)
          elsif removing_suppliers?
            supplier_ids = current_supplier_ids - new_supplier_ids
            @product.remove_suppliers!(supplier_ids)
            @product.add_suppliers!(new_supplier_ids) if new_supplier_ids
          elsif same_number_of_suppliers? && different_suppliers?
            @product.remove_suppliers!(current_suppliers)
            @product.add_suppliers!(new_suppliers)
          elsif same_suppliers?
            #noop
          end
        end

        def adding_suppliers?
          new_supplier_ids.count > current_supplier_ids.count
        end

        def removing_suppliers?
          new_supplier_ids.count < current_supplier_ids.count
        end

        def same_suppliers?
          new_supplier_ids == current_supplier_ids
        end

        def same_number_of_suppliers?
          new_supplier_ids.count == current_supplier_ids.count
        end

        def different_suppliers?
          new_supplier_ids.sort != current_supplier_ids.sort
        end

        def new_supplier_ids
          return [] unless params["product"].present? && params["product"]["supplier_ids"].present?
          params["product"]["supplier_ids"].split(",").map(&:to_i)
        end

        def current_supplier_ids
          @product.supplier_ids
        end

        def get_suppliers
          @suppliers = ::Spree::Supplier.order(:name)
        end

        # Scopes the collection to what the user should have access to, based on the user's role
        def supplier_collection
          return unless try_spree_current_user

          if try_spree_current_user.supplier?
            @collection = @collection.joins(:suppliers).where('spree_suppliers.id = ?', try_spree_current_user.supplier_id)
          end
        end

        # Newly added products by a Supplier are associated with it.
        def add_product_to_supplier
          if try_spree_current_user&.supplier?
           @product.add_supplier!(try_spree_current_user.supplier_id)
          elsif user_admin?
            @product.add_suppliers!(new_supplier_ids)
          end
        end

        def user_admin?
          try_spree_current_user.admin?
        end

        ::Spree::Admin::ProductsController.prepend self
      end
    end
  end
end
