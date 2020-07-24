# frozen_string_literal: true

module SolidusMarketplace
  module Spree
    module BaseControllerDecorator
      def self.prepended(base)
        base.prepend_before_action :redirect_supplier
      end

      private

      def redirect_supplier
        if ['/admin', '/admin/authorization_failure'].include?(request.path) && try_spree_current_user.try(:supplier)
          redirect_to '/admin/shipments' and return false
        end
      end

      ::Spree::BaseController.prepend self
    end
  end
end
