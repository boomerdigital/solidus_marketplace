# frozen_string_literal: true

module SolidusMarketplace
  module Spree
    module VariantDecorator
      def self.prepended(base)
        base.has_many :supplier_variants
        base.has_many :suppliers, through: :supplier_variants
        base.before_create :populate_for_suppliers
      end

      private

      def create_stock_items
        ::Spree::StockLocation.all.each do |stock_location|
          if stock_location.supplier_id.blank? || self.suppliers.pluck(:id).include?(stock_location.supplier_id)
            stock_location.propagate_variant(self) if stock_location.propagate_all_variants?
          end
        end
      end

      def populate_for_suppliers
        self.suppliers = self.product.suppliers
      end

      ::Spree::Variant.prepend self
    end
  end
end
