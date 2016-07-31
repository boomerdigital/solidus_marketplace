Spree::Product.class_eval do

  belongs_to :supplier, touch: true

  def add_supplier!(supplier)
  	self.supplier = supplier
  	self.save!
  end


  # Returns true if the product has a drop shipping supplier.
  def supplier?
    supplier.present?
  end

end
