# frozen_string_literal: true

module SolidusMarketplace
  module Spree
    module Api
      module ApiHelpersDecorator
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
          :slug
        ]

        mattr_reader(:supplier_attributes)

        ::Spree::Api::ApiHelpers.prepend self
      end
    end
  end
end
