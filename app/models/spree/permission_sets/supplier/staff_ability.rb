# frozen_string_literal: true

require 'cancan'

module Spree
  module PermissionSets
    module Supplier
      class StaffAbility < PermissionSets::Base

        def activate!
          cannot %i[read], 
              Spree::Product

          can %i[read admin edit],
              Spree::Product,
              suppliers: { id: user.supplier_id }

          can %i[admin manage],
              Spree::StockItem,
              stock_location_id: supplier_stock_location_ids

          cannot %i[read], 
              Spree::StockLocation

          can :read,
              Spree::StockLocation,
              id: supplier_stock_location_ids
        end

        private

        def supplier_stock_location_ids
          @ids ||= user.supplier.stock_locations.pluck(:id)
        end
      end
    end
  end
end
