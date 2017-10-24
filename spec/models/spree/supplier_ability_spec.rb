require 'spec_helper'
require 'cancan/matchers'
require 'spree/testing_support/ability_helpers'

describe Spree::SupplierAbility do

  let(:supplier) { create(:supplier) }
  let(:supplier_admin_role) { build :role, name: "supplier_admin" }
  let(:user) { create(:user, supplier: supplier) }
  let(:ability) { Spree::SupplierAbility.new(user) }
  let(:token) { nil }

  before(:each) do
    user.spree_roles << supplier_admin_role
  end

  context 'for Dash' do
    let(:resource) { Spree::Admin::RootController }

    context 'requested by supplier' do
      it_should_behave_like 'access denied'
      it_should_behave_like 'no index allowed'
      it_should_behave_like 'admin denied'
    end
  end

  context 'for Product' do
    let(:resource) { create(:product) }

    before(:each) do
      resource.add_supplier!(user.supplier)
      resource.reload
    end

    it_should_behave_like 'index allowed'
    it_should_behave_like 'read and update access granted'
    it_should_behave_like 'admin granted'

    context 'requested by another suppliers user' do
      let(:other_resource) {
        product = create(:product)
        product.add_supplier!(create(:supplier))
        product
      }
      it { expect(ability).to_not be_able_to :read, other_resource }
    end

    context 'requested by suppliers user' do
      let(:resource) {
        product = create(:product)
        product.add_supplier!(user.supplier)
        product.reload
      }
      # it_should_behave_like 'access granted'
      it { expect(ability).to be_able_to :read, resource }
      it { expect(ability).to be_able_to :stock, resource }
    end
  end

  context 'for Shipment' do
    context 'requested by another suppliers user' do
      let(:resource) { Spree::Shipment.new({stock_location: create(:stock_location, supplier: create(:supplier))}) }
      it_should_behave_like 'access denied'
      it_should_behave_like 'no index allowed'
      it_should_behave_like 'admin denied'
      it { expect(ability).to_not be_able_to :ready, resource }
      it { expect(ability).to_not be_able_to :ship, resource }
    end

    context 'requested by suppliers user' do
      context 'when order is complete' do
        let(:resource) {
          order = create(:completed_order_from_supplier_with_totals)
          order.stock_locations.first.update_attribute :supplier, user.supplier
          Spree::Shipment.new({order: order, stock_location: order.stock_locations.first })
        }
        it_should_behave_like 'read only'
        it_should_behave_like 'index allowed'
        it_should_behave_like 'admin granted'
      end

      context 'when order is incomplete' do
        let(:resource) { Spree::Shipment.new({stock_location: create(:stock_location, supplier: user.supplier)}) }
        it_should_behave_like 'access denied'
        it { expect(ability).to_not be_able_to :ready, resource }
        it { expect(ability).to_not be_able_to :ship, resource }
      end
    end
  end

  context 'for StockItem' do
    let(:resource) { Spree::StockItem }

    it_should_behave_like 'index allowed'
    it_should_behave_like 'admin granted'

    context 'requested by another suppliers user' do
      let(:resource) {
        supplier = create(:supplier)
        variant = create(:product).master
        variant.product.add_supplier! supplier
        supplier.stock_locations.first.stock_items.first
      }
      it_should_behave_like 'access denied'
    end

    context 'requested by suppliers user' do
      let(:resource) {
        variant = create(:product).master
        variant.product.add_supplier! user.supplier
        user.supplier.stock_locations.first.stock_items.first
      }
      it_should_behave_like 'access granted'
    end
  end

  context 'for StockLocation' do
    context 'requsted by another suppliers user' do
      let(:resource) {
        supplier = create(:supplier)
        variant = create(:product).master
        variant.product.add_supplier! supplier
        supplier.stock_locations.first
      }
      it_should_behave_like 'access denied'
    end

    context 'requested by suppliers user' do
      let(:resource) {
        variant = create(:product).master
        variant.product.add_supplier! user.supplier
        user.supplier.stock_locations.first
      }
      it_should_behave_like 'access granted'
      it_should_behave_like 'admin granted'
      it_should_behave_like 'index allowed'
    end
  end

  context 'for StockMovement' do
    let(:resource) { Spree::StockMovement }

    it_should_behave_like 'index allowed'
    it_should_behave_like 'admin granted'

    context 'requested by another suppliers user' do
      let(:resource) {
        supplier = create(:supplier)
        variant = create(:product).master
        variant.product.add_supplier! supplier
        Spree::StockMovement.new({ stock_item: supplier.stock_locations.first.stock_items.first })
      }
      it_should_behave_like 'admin denied'
    end

    context 'requested by suppliers user' do
      let(:resource) {
        variant = create(:product).master
        variant.product.add_supplier! user.supplier
        Spree::StockMovement.new({ stock_item: user.supplier.stock_locations.first.stock_items.first })
      }
      it_should_behave_like 'access granted'
    end
  end

  context 'for Supplier' do
    context 'requested by any user' do
      let(:ability) { Spree::SupplierAbility.new(create(:user)) }
      let(:resource) { Spree::Supplier }

      it_should_behave_like 'admin denied'
      it_should_behave_like 'access denied'
    end

    context 'requested by suppliers user' do
      let(:resource) { user.supplier }
      it_should_behave_like 'admin granted'
      it_should_behave_like 'read and update access granted'
    end
  end

end
