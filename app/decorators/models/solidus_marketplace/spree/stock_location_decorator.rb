# frozen_string_literal: true

module SolidusMarketplace
  module Spree
    module StockLocationDecorator
      def self.prepended(base)
        base.belongs_to :supplier, class_name: '::Spree::Supplier', optional: true
        base.scope :by_supplier, -> (supplier_id) { where(supplier_id: supplier_id) }
      end

      # Wrapper for creating a new stock item respecting the backorderable config and supplier
      def propagate_variant(variant)
        if self.supplier_id.blank? || variant.suppliers.pluck(:id).include?(self.supplier_id)
          self.stock_items.create!(variant: variant, backorderable: self.backorderable_default)
        end
      end

      def unpropagate_variant(variant)
        stock_items = self.stock_items.where(variant: variant)
        stock_items.map(&:destroy)
      end

      def available?(variant)
        stock_item(variant).try(:available?)
      end

      ::Spree::StockLocation.prepend self
    end
  end
end
