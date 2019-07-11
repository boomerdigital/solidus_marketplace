# frozen_string_literal: true

module SolidusMarketplace
  class Configuration < Spree::Preferences::Configuration
    # Determines if send orders directly to supplier.
    preference :automatically_deliver_orders_to_supplier, :boolean, default: true
    # Default flat rate to charge suppliers per order for commission.
    preference :default_commission_flat_rate, :decimal, default: 0.0
    # Default percentage to charge suppliers per order for commission.
    preference :default_commission_percentage, :decimal, default: 0.0
    # Determines whether or not to email a new supplier their welcome email.
    preference :send_supplier_email, :boolean, default: true
  end
end
