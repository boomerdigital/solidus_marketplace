module SolidusMarketplace
  module ShipmentDecorator
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)
      belongs_to :order, class_name: 'Spree::Order', touch: true, inverse_of: :shipments
      has_many :payments, as: :payable
      scope :by_supplier, -> (supplier_id) { joins(:stock_location).where(spree_stock_locations: { supplier_id: supplier_id }) }
      delegate :supplier, to: :stock_location
      self.whitelisted_ransackable_attributes = ["number", "state"]
    end

    module InstanceMethods
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
    end
  end
end
