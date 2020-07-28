# frozen_string_literal: true

module SolidusMarketplace
  module Spree
    module ShipmentDecorator
      def self.prepended(base)
        base.belongs_to :order, class_name: '::Spree::Order', touch: true, inverse_of: :shipments
        base.has_many :payments, as: :payable
        base.scope :by_supplier, -> (supplier_id) { joins(:stock_location).where(spree_stock_locations: { supplier_id: supplier_id }) }
        base.delegate :supplier, to: :stock_location
        base.whitelisted_ransackable_attributes = ["number", "state"]
      end

      def display_final_price_with_items
        Spree::Money.new final_price_with_items
      end

      def final_price_with_items
        self.item_cost + self.final_price
      end

      # TODO move commission to spree_marketplace?
      def supplier_commission_total
        ((self.final_price_with_items * self.supplier.commission_percentage / 100) + self.supplier.commission_flat_rate)
      end

      private

      def after_ship
        super

        if supplier.present?
          update_commission
        end
      end

      def update_commission
        update_column(:supplier_commission, self.supplier_commission_total)
      end

      ::Spree::Shipment.prepend self
    end
  end
end
