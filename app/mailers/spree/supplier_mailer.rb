module Spree
  class SupplierMailer < Spree::BaseMailer
    default from: Spree::Store.default.mail_from_address

    def welcome(supplier_id)
      @supplier = Spree::Supplier.find(supplier_id)
      mail to: @supplier.user.email,
           subject: t('spree.supplier_mailer.welcome.subject')
    end
  end
end
