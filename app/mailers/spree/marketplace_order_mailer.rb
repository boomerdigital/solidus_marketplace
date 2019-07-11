module Spree
  class MarketplaceOrderMailer < Spree::BaseMailer
    default from: Spree::Store.default.mail_from_address

    def supplier_order(shipment_id)
      @shipment = Spree::Shipment.find(shipment_id)
      @supplier = @shipment.supplier
      subject = t('spree.marketplace_order_mailer.supplier_order.subject',
        name: Spree::Store.current.name, number: @shipment.number)

      mail to: @supplier.user.email,
           subject: subject
    end
  end
end
