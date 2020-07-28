# frozen_string_literal: true

module Spree
  class SupplierVariant < Spree::Base
    belongs_to :supplier
    belongs_to :variant, class_name: 'Spree::Variant', touch: true
  end
end
