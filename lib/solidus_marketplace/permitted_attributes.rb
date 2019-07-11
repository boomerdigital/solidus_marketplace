# frozen_string_literal: true

module SolidusMarketplace
  module PermittedAttributes
    class << self
      @@supplier_attributes = [
        :id,
        :address_id,
        :commission_flat_rate,
        :commission_percentage,
        :user_id,
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
  end
end
