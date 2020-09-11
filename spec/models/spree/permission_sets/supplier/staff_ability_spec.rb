# frozen_string_literal: true

require 'cancan'
require 'cancan/matchers'
require 'spree/testing_support/ability_helpers'

describe Spree::PermissionSets::Supplier::AdminAbility do
  let(:ability) { Spree::Ability.new(user) }
  let(:supplier) { create(:supplier) }
  let(:supplier_staff_role) { build(:role, name: 'supplier_staff') }
  let(:user) { create(:user, supplier: supplier) }
  let(:token) { nil }

  subject { ability }

  before(:each) do
    user.spree_roles << supplier_staff_role
    described_class.new(ability).activate!
  end

  context 'for Product' do
    context 'requested by another suppliers user' do
      let(:other_resource) { create(:product) }

      before do
        other_resource.add_supplier!(create(:supplier))
        other_resource.reload
      end

      it { expect(ability).to_not be_able_to :read, other_resource }
      it { expect(ability).to_not be_able_to :admin, other_resource }
      it { expect(ability).to_not be_able_to :edit, other_resource }
    end

    context 'requested by suppliers user' do
      let(:resource) { create(:product) }

      before(:each) do
        resource.add_supplier!(user.supplier)
        resource.reload
      end
  
      it { expect(ability).to be_able_to :read, resource }
      it { expect(ability).to be_able_to :admin, resource }
      it { expect(ability).to be_able_to :edit, resource }
    end
  end

  context 'for StockItem' do
    let(:resource) { Spree::StockItem }

    context 'requested by another suppliers user' do
      let(:resource) {
        supplier = create(:supplier)
        variant = create(:product).master
        variant.product.add_supplier! supplier
        supplier.stock_locations.first.stock_items.first
      }
      
      it { expect(ability).to_not be_able_to :admin, resource }
    end

    context 'requested by suppliers user' do
      let(:resource) {
        variant = create(:product).master
        variant.product.add_supplier! user.supplier
        user.supplier.stock_locations.first.stock_items.first
      }

      it { expect(ability).to be_able_to :admin, resource }
    end
  end

  context 'for StockLocation' do
    context 'requested by another suppliers user' do
      let(:resource) {
        supplier = create(:supplier)
        variant = create(:product).master
        variant.product.add_supplier! supplier
        supplier.stock_locations.first
      }

      it { expect(ability).to_not be_able_to :read, resource }
    end

    context 'requested by suppliers user' do
      let(:resource) {
        variant = create(:product).master
        variant.product.add_supplier! user.supplier
        user.supplier.stock_locations.first
      }

      it { expect(ability).to be_able_to :read, resource }
    end
  end
end
