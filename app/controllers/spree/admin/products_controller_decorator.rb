Spree::Admin::ProductsController.class_eval do

  before_action :get_suppliers, only: [:edit, :update]
  before_action :supplier_collection, only: [:index]
  create.after :add_product_to_supplier

  private

  def get_suppliers
    @suppliers = Spree::Supplier.order(:name)
  end

  # Scopes the collection to the Supplier
  # Doesn't work with normal hash conditions on the ability, due to the
  # LEFT OUTER JOIN that occurs from ransack instead of an inner join.
  def supplier_collection
    if try_spree_current_user && !try_spree_current_user.admin? && try_spree_current_user.supplier?
      @collection = @collection.joins(:suppliers).where('spree_suppliers.id = ?', try_spree_current_user.supplier_id)
    end
  end

  # Newly added products by a Supplier are associated with it.
  def add_product_to_supplier
    if try_spree_current_user && try_spree_current_user.supplier?
     @product.add_supplier!(try_spree_current_user.supplier_id)
    end
  end

end
