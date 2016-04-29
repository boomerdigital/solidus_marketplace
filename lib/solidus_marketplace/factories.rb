FactoryGirl.define do
  # Define your Spree extensions Factories within this file to enable applications, and other extensions to use and override them.
  #
  # Example adding this to your spec_helper will load these Factories for use:
  # require 'solidus_marketplace/factories'


  factory :supplier, :class => Spree::Supplier do
    sequence(:name) { |i| "Big Store #{i}" }
    email { Faker::Internet.email }
    url "http://example.com"
    address
    # Creating a stock location with a factory instead of letting the model handle it
    # so that we can run tests with backorderable defaulting to true.
    before :create do |supplier|
      supplier.stock_locations << build(:stock_location, name: supplier.name, supplier: supplier)
    end

    factory :supplier_with_commission do
      commission_flat_rate 0.5
      commission_percentage 10
    end
  end

  factory :supplier_user, parent: :user do
    supplier
  end

  factory :variant_with_supplier, parent: :variant do
    after :create do |variant|
      variant.product.add_supplier! create(:supplier)
    end
  end
end
