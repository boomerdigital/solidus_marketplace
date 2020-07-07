Spree::StockLocation.class_eval do

  belongs_to :supplier, class_name: 'Spree::Supplier', optional: true

  scope :by_supplier, -> (supplier_id) { where(supplier_id: supplier_id) }

  # Wrapper for creating a new stock item respecting the backorderable config and supplier
  durably_decorate :propagate_variant, mode: 'soft', sha: '68fd322da48facbdbf567a2391c2495d04c3c8bc' do |variant|
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

end
