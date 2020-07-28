# frozen_string_literal: true

module SolidusMarketplace
  module Spree
    module ProductDecorator
      def self.prepended(base)
        base.has_many :suppliers, -> { readonly }, through: :master
        base.scope :of_supplier, -> (supplier_id) { joins(:suppliers).where('spree_suppliers.id = ?', supplier_id) }
      end

      def add_supplier!(supplier_or_id)
        supplier = supplier_or_id.is_a?(::Spree::Supplier) ? supplier_or_id : ::Spree::Supplier.find(supplier_or_id)
        populate_for_supplier! supplier if supplier
      end

      def add_suppliers!(supplier_ids)
        ::Spree::Supplier.where(id: supplier_ids).each do |supplier|
          populate_for_supplier! supplier
        end
      end

      def remove_suppliers!(supplier_ids)
        ::Spree::Supplier.where(id: supplier_ids).each do |supplier|
          unpopulate_for_supplier! supplier
        end
      end

      # Returns true if the product has one or more suppliers.
      def supplier?
        suppliers.present?
      end

      private

      def populate_for_supplier!(supplier)
        variants_including_master.each do |variant|
          unless variant.suppliers.pluck(:id).include?(supplier.id)
            variant.suppliers << supplier
            supplier.stock_locations.each { |location| location.propagate_variant(variant) unless location.stock_item(variant) }
          end
        end
      end

      def unpopulate_for_supplier!(supplier)
        variants_including_master.each do |variant|
          if variant.suppliers.pluck(:id).include?(supplier.id)
            variant.suppliers.delete(supplier)

            supplier.stock_locations.each do |location|
              location.unpropagate_variant(variant)
            end
          end
        end
      end

      ::Spree::Product.prepend self
    end
  end
end
