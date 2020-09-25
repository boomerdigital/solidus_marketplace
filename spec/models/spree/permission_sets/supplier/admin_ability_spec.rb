# frozen_string_literal: true

require 'cancan'
require 'cancan/matchers'
require 'spree/testing_support/ability_helpers'

describe Spree::PermissionSets::Supplier::AdminAbility do
  let(:ability) { Spree::Ability.new(user) }
  let(:supplier) { create(:supplier) }
  let(:supplier_admin_role) { build(:role, name: 'supplier_admin') }
  let(:user) { create(:user, supplier: supplier) }
  let(:token) { nil }
  let(:product) { create(:product) }
  let(:variant) { product.master }
  let(:other_supplier) { create(:supplier) }

  subject { ability }

  before(:each) do
    user.spree_roles << supplier_admin_role
    described_class.new(ability).activate!
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
    it_should_behave_like 'access granted'
    it_should_behave_like 'admin granted'

    context 'requested by another suppliers user' do
      let(:other_resource) { create(:product) }

      before do
        other_resource.add_supplier!(create(:supplier))
        other_resource.reload
      end

      it { expect(ability).to_not be_able_to :read, other_resource }
    end

    context 'requested by suppliers user' do
      it_should_behave_like 'access granted'

      it { expect(ability).to be_able_to :read, resource }
      it { expect(ability).to be_able_to :stock, resource }
    end
  end

  context 'for Shipment' do
    context 'requested by another suppliers user' do
      let(:resource) do
        Spree::Shipment.new({stock_location: create(:stock_location,
                                                    supplier: create(:supplier))})
      end

      it_should_behave_like 'access denied'
      it_should_behave_like 'no index allowed'
      it_should_behave_like 'admin denied'

      it { expect(ability).to_not be_able_to :ready, resource }
      it { expect(ability).to_not be_able_to :ship, resource }
    end

    context 'requested by suppliers user' do
      context 'when order is complete' do
        let(:order) { create(:completed_order_from_supplier_with_totals) }
        let(:resource) do
          Spree::Shipment.new({ order: order,
                                stock_location: order.stock_locations.first })
        end

        before do
          order.stock_locations.first.update_attribute :supplier, user.supplier
        end

        it_should_behave_like 'index allowed'
        it_should_behave_like 'admin granted'
      end

      context 'when order is incomplete' do
        let(:resource) do
          Spree::Shipment.new({stock_location: create(:stock_location,
                                                      supplier: user.supplier)})
        end

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
        other_supplier.stock_locations.first.stock_items.first
      }

      before do
        variant.product.add_supplier! other_supplier
      end

      it_should_behave_like 'access denied'
    end

    context 'requested by suppliers user' do
      let(:resource) {
        user.supplier.stock_locations.first.stock_items.first
      }

      before do
        variant.product.add_supplier! user.supplier
      end

      it_should_behave_like 'access granted'
    end
  end

  context 'for StockLocation' do
    context 'requsted by another suppliers user' do
      let(:resource) { other_supplier.stock_locations.first }
      before do
        variant.product.add_supplier! other_supplier
      end
      it_should_behave_like 'access denied'
    end

    context 'requested by suppliers user' do
      let(:resource) {
        variant = create(:product).master
        variant.product.add_supplier! user.supplier
        user.supplier.stock_locations.first
      }

      it { expect(ability).to be_able_to :admin, resource }
      it { expect(ability).to be_able_to :read, resource }
      it { expect(ability).to be_able_to :update, resource }
      it { expect(ability).to be_able_to :index, resource }
      it { expect(ability).to be_able_to :create, resource }
      it { expect(ability).to be_able_to :edit, resource }
    end
  end

  context 'for StockMovement' do
    let(:resource) { Spree::StockMovement }

    it_should_behave_like 'index allowed'
    it_should_behave_like 'admin granted'

    context 'requested by another suppliers user' do
      let(:resource) {
        Spree::StockMovement.new({ stock_item: other_supplier.stock_locations.
          first.stock_items.first })
      }
      before do
        variant.product.add_supplier! other_supplier
      end

      it_should_behave_like 'admin denied'
    end

    context 'requested by suppliers user' do
      let(:resource) {
        Spree::StockMovement.new({ stock_item: user.supplier.stock_locations.
          first.stock_items.first })
      }

      before do
        variant.product.add_supplier!(user.supplier)
      end

      it_should_behave_like 'access granted'
    end
  end

  context 'for Supplier' do
    context 'requested by any user' do
      let(:ability) { Spree::Ability.new(user) }
      let(:resource) { create(:supplier) }

      it { expect(ability).to_not be_able_to :index, resource }
      it { expect(ability).to_not be_able_to :create, resource }
    end

    context 'requested by suppliers user' do
      let(:resource) { user.supplier }

      it { expect(ability).to be_able_to :admin, resource }
      it { expect(ability).to be_able_to :read, resource }
      it { expect(ability).to be_able_to :update, resource }
    end
  end
end
