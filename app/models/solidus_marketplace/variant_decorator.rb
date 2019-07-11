module SolidusMarketplace
  module VariantDecorator
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)
      has_many :supplier_variants
      has_many :suppliers, through: :supplier_variants
      before_create :populate_for_suppliers
    end

    module InstanceMethods
      private

      def create_stock_items
        Spree::StockLocation.all.each do |stock_location|
          if stock_location.supplier_id.blank? || self.suppliers.pluck(:id).include?(stock_location.supplier_id)
            stock_location.propagate_variant(self) if stock_location.propagate_all_variants?
          end
        end
      end

      def populate_for_suppliers
        self.suppliers = self.product.suppliers
      end
    end
  end
end
