# frozen_string_literal: true

FactoryBot.define do
  factory :supplier, class: Spree::Supplier do
    sequence(:name) { |i| "Big Store #{i}" }
    url { 'http://example.com' }
    address
    commission_flat_rate { 0.0 }
    commission_percentage { 10.0 }
    # Creating a stock location with a factory instead of letting the model handle it
    # so that we can run tests with backorderable defaulting to true.
    before :create do |supplier|
      supplier.stock_locations << build(:stock_location,
                                        name: supplier.name,
                                        supplier: supplier)
    end

    factory :supplier_with_commission do
      commission_flat_rate { 0.5 }
      commission_percentage { 10 }
    end
  end

  factory :supplier_admin_role, parent: :role do
    name { 'supplier_admin' }
  end

  factory :supplier_admin, parent: :user do
    supplier

    after :create do |user|
      user.spree_roles << create(:supplier_admin_role)
    end
  end

  factory :supplier_staff_role, parent: :role do
    name { 'supplier_staff' }
  end

  factory :supplier_staff, parent: :user do
    supplier

    after :create do |user| 
      user.spree_roles << create(:supplier_staff_role)
    end
  end

  factory :variant_with_supplier, parent: :variant do
    after :create do |variant|
      variant.product.add_supplier! create(:supplier)
    end
  end

  factory :order_from_supplier, parent: :order do
    bill_address
    ship_address

    transient do
      line_items_count { 5 }
    end

    after(:create) do |order, evaluator|
      supplier = create(:supplier)
      product = create(:product)
      product.add_supplier! supplier
      product_2 = create(:product)
      product_2.add_supplier! create(:supplier)

      create_list(:line_item, evaluator.line_items_count,
        order: order,
        variant: product_2.master
      )

      order.line_items.reload
      create(:shipment, order: order, stock_location: supplier.stock_locations.first)
      order.shipments.reload
      order.recalculate
    end

    factory :completed_order_from_supplier_with_totals do
      state { 'complete' }

      after(:create) do |order|
        order.refresh_shipment_rates
        order.update_column(:completed_at, Time.now)
      end

      factory :order_from_supplier_ready_to_ship do
        payment_state { 'paid' }
        shipment_state { 'ready' }

        after(:create) do |order|
          create(:payment, amount: order.total, order: order, state: 'completed')
          order.shipments.each do |shipment|
            shipment.inventory_units.each { |u| u.update_column('state', 'on_hand') }
            shipment.update_column('state', 'ready')
          end
          order.reload
        end

        factory :shipped_order_from_supplier do
          after(:create) do |order|
            order.shipments.each do |shipment|
              shipment.inventory_units.each { |u| u.update_column('state', 'shipped') }
              shipment.update_column('state', 'shipped')
            end
            order.reload
          end
        end
      end
    end
  end
end
