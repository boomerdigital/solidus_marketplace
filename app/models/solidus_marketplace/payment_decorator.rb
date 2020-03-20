module SolidusMarketplace
  module PaymentDecorator
    extend ActiveSupport::Concern

    included do
      belongs_to :payable, polymorphic: true,  optional: true
    end
  end
end
