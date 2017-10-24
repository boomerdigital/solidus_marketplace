module Spree
  class MarketplaceConfiguration < Preferences::Configuration

    # Default flat rate to charge suppliers per order for commission.
    preference :default_commission_flat_rate, :float, default: 0.0

    # Default percentage to charge suppliers per order for commission.
    preference :default_commission_percentage, :float, default: 0.0

    # Determines whether or not to email a new supplier their welcome email.
    preference :send_supplier_email, :boolean, default: true

  end
end
