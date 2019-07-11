module Spree
  module Admin
    class MarketplaceSettingsController < Spree::Admin::BaseController
      def edit
        @config = SolidusMarketplace::Config
      end

      def update
        config = SolidusMarketplace::Config

        params.each do |name, value|
          next unless config.has_preference? name
          config[name] = value
        end

        flash[:success] = t('spree.admin.marketplace_settings.update.success')
        redirect_to spree.edit_admin_marketplace_settings_path
      end
    end
  end
end
