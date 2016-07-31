Spree::Admin::ProductsController.class_eval do

  before_filter :get_suppliers, only: [:edit, :update]
  before_filter :supplier_collection, only: [:index]
  create.after :set_supplier

  private

  def get_suppliers
    @suppliers = Spree::Supplier.order(:name)
  end

  def set_supplier
    if try_spree_current_user.supplier?
      @product.add_supplier(try_spree_current_user.supplier)
    end
  end

  # Scopes the collection to the Supplier.
  def supplier_collection
    if try_spree_current_user && !try_spree_current_user.admin? && try_spree_current_user.supplier?
      @collection = @collection.joins(:supplier).where('spree_suppliers.id = ?', try_spree_current_user.supplier_id)
    end
  end

end
