# frozen_string_literal: true

# This module is responsible for managing what attributes can be updated
# through the api. It also overrides Spree::Permitted attributes to allow the
# solidus api to accept nested params for subscription models as well

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
    end

    mattr_reader(:supplier_attributes)
  end
end
