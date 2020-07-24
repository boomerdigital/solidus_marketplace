# frozen_string_literal: true

describe Spree::Stock::Splitter::Marketplace do
  let(:stock_location) { create(:stock_location) }
  let(:supplier1) { create(:supplier, stock_locations: [stock_location]) }
  let(:supplier2) { create(:supplier, stock_locations: [stock_location]) }
  let(:variant) do
    variant = create(:variant)
    variant.product.add_supplier!(supplier1)
    variant.reload.supplier_variants.find_by_supplier_id(supplier1.id).
      update_column(:cost, 5)
    variant.product.add_supplier!(supplier2)
    variant.reload.supplier_variants.find_by_supplier_id(supplier2.id).
      update_column(:cost, 6)
    variant
  end

  subject { described_class.new(stock_location) }

  it 'splits packages for suppliers to ship' do
    package = Spree::Stock::Package.new(stock_location)
    2.times { package.add build(:inventory_unit, variant: variant) }
    packages = subject.split([package])
    expect(packages.count).to eq(2)
  end
end
