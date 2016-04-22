class Spree::Supplier < Spree::Base
  belongs_to :address, class_name: 'Spree::Address'

end