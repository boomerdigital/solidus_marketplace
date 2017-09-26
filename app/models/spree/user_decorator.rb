Spree.user_class.class_eval do

  belongs_to :supplier, class_name: 'Spree::Supplier'

  has_many :variants, through: :supplier

  def supplier?
    supplier.present?
  end

  def has_admin_role?
    spree_roles.map(&:name).include?("admin")
  end

end
