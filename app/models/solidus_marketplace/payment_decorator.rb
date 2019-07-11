module SolidusMarketplace
  module PaymentDecorator
    extend ActiveSupport::Concern

    included do
      belongs_to :payable, polymorphic: true
    end
  end
end
