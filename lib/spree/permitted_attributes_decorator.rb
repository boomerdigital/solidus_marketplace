Spree::PermittedAttributes.class_eval do
  @@supplier_attributes = [
    :id,
    :address_id,
    :commission_flat_rate,
    :commission_percentage,
    :email,
    :name,
    :url,
    :deleted_at,
    :tax_id,
    :token,
    :slug,
    :paypal_email
  ]

  mattr_reader(:supplier_attributes)
end
