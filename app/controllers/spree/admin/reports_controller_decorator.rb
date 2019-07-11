if defined?(SolidusReports::Engine)
  Spree::Admin::ReportsController.include(SolidusMarketplace::Admin::ReportsControllerDecorator)
end
