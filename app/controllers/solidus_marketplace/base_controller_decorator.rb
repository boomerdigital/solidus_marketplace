module SolidusMarketplace
  module BaseControllerDecorator
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)
      prepend_before_action :redirect_supplier
    end

    module InstanceMethods
      private

      def redirect_supplier
        if ['/admin', '/admin/authorization_failure'].include?(request.path) && try_spree_current_user.try(:supplier)
          redirect_to '/admin/shipments' and return false
        end
      end
    end
  end
end
