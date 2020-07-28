# frozen_string_literal: true

module SolidusMarketplace
  module Spree
    module PaymentDecorator
      def self.prepended(base)
        base.belongs_to :payable, polymorphic: true,  optional: true
      end

      ::Spree::Payment.prepend self
    end
  end
end
