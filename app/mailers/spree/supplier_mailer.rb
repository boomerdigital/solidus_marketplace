module Spree
  class SupplierMailer < Spree::BaseMailer

    default from: Spree::Store.default.mail_from_address

    def welcome(supplier_id)
      @supplier = Supplier.find supplier_id
      mail to: @supplier.email, subject:I18n.t('spree_supplier_mailer.welcome.subject')
    end

  end
end
