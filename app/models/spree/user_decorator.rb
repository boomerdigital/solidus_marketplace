Spree.user_class.class_eval do

  belongs_to :supplier, class_name: 'Spree::Supplier', optional: true

  has_many :variants, through: :supplier

  def supplier?
    supplier.present?
  end

  def supplier_admin?
    spree_roles.map(&:name).include?("supplier_admin")
  end

  def market_maker?
    has_admin_role?
  end

  def has_admin_role?
    spree_roles.map(&:name).include?("admin")
  end

end
