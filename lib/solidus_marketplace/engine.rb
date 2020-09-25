# frozen_string_literal: true

require 'spree/core'

require 'solidus_marketplace'
require 'solidus_marketplace/permitted_attributes'

module SolidusMarketplace
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    isolate_namespace ::Spree
    engine_name 'solidus_marketplace'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'solidus_marketplace.custom_splitters', after: 'spree.register.stock_splitters' do |app|
      app.config.spree.stock_splitters << Spree::Stock::Splitter::Marketplace
    end

    initializer 'solidus_marketplace.preferences', before: :load_config_initializers  do |app|
      SolidusMarketplace::Config = SolidusMarketplace::Configuration.new
      Spree::PermittedAttributes.singleton_class.prepend(SolidusMarketplace::PermittedAttributes)
      Spree::Config.roles.assign_permissions :supplier_admin, ['Spree::PermissionSets::Supplier::AdminAbility']
      Spree::Config.roles.assign_permissions :supplier_staff, ['Spree::PermissionSets::Supplier::StaffAbility', 'Spree::PermissionSets::OrderManagement']
    end

    initializer 'solidus_marketplace' do
      next unless ::Spree::Backend::Config.respond_to?(:menu_items)
      ::Spree::Backend::Config.configure do |config|
        config.menu_items << Spree::BackendConfiguration::MenuItem.new(
          [:stock_locations],
          'globe',
          condition: -> { can?(:index, ::Spree::StockLocation) },
        )

        config.menu_items << Spree::BackendConfiguration::MenuItem.new(
          [:suppliers],
          'home',
          condition: -> { can?(:index, ::Spree::Supplier) },
        )

        config.menu_items << Spree::BackendConfiguration::MenuItem.new(
          [:shipments],
          'plane',
          condition: -> { can?(:index, ::Spree::Shipment) },
        )
      end
    end
  end
end
