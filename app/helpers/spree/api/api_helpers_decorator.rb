module Spree
  module Api
    module ApiHelpers

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
        :slug
      ]

      mattr_reader(:supplier_attributes)
    end
  end
end
