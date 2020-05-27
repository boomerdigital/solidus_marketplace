module Spree
  module Stock
    module Splitter
      class Marketplace < Spree::Stock::Splitter::Base

        def split(packages)
          begin
            split_packages = []
            packages.each do |package|
              # Package fulfilled items together.
              fulfilled = package.contents.select { |content|
                begin
                  content.variant.suppliers.count == 0 ||
                  content.variant.suppliers.detect { |supplier| supplier.stock_locations_with_available_stock_items(content.variant).empty? }
                rescue => e
                end
              }
              split_packages << build_package(fulfilled)
              # Determine which supplier to package shipped items.
              supplier_contents = package.contents.select do |content|
                content.variant.suppliers.count > 0 &&
                content.variant.suppliers.detect { |supplier| supplier.stock_locations_with_available_stock_items(content.variant).any? }
              end
              supplier_contents.each do |content|
                # Select the related variant
                variant = content.variant
                # Select suppliers ordering ascending according to cost.
                suppliers = variant.supplier_variants.order("spree_supplier_variants.cost ASC").map(&:supplier)
                # Select first supplier that has stock location with avialable stock item.
                available_supplier = suppliers.detect do |supplier|
                  supplier.stock_locations_with_available_stock_items(variant).any?
                end
                # Select the first available stock location with in the available_supplier stock locations.
                stock_location = available_supplier.stock_locations_with_available_stock_items(variant).first
                # Add to any existing packages or create a new one.
                if existing_package = split_packages.detect { |p| p.stock_location == stock_location }
                  existing_package.contents << content
                else
                  split_packages << Spree::Stock::Package.new(stock_location, [content])
                end
              end
            end
          rescue => e
          end
          return_next split_packages
        end

      end
    end
  end
end
