require 'spec_helper'

describe Spree.user_class do

  it { should belong_to(:supplier) }

  it { should have_many(:variants).through(:supplier) }

  let(:user) { build :user }
  let(:admin_role) { build :admin_role }

  describe '#supplier?' do
    it "returns true if user is a supplier" do
      user.supplier = build :supplier
      expect(user.supplier?).to eq true
    end

    it "returns false if user is not a supplier" do
      expect(user.supplier?).to eq false
    end
  end

  describe '#supplier_admin?' do
    context "when user is a supplier" do
      before(:each) do
        user.supplier = build :supplier
      end

      it "returns true if user has admin role" do
        user.spree_roles << admin_role
        expect(user.supplier_admin?).to eq true
      end

      it "returns false if user doesn't have an admin role" do
        expect(user.supplier_admin?).to eq false
      end
    end

    context "when user is not a supplier" do
      it "returns false if user has admin role" do
        user.spree_roles << admin_role
        expect(user.supplier_admin?).to eq false
      end

      it "returns false if user doesn't have admin role" do
        expect(user.supplier_admin?).to eq false
      end
    end
  end

  describe '#market_maker?' do
    context "when user is a supplier" do
      it "returns false if user has an admin role" do
        user.spree_roles << admin_role
        user.supplier = build :supplier
        expect(user.market_maker?).to eq false
      end

      it "returns false if user doesn't have an admin role" do
        user.supplier = build :supplier
        expect(user.market_maker?).to eq false
      end
    end

    context "when user is not a supplier" do
      it "returns true if user has admin role" do
        user.spree_roles << admin_role

        expect(user.market_maker?).to eq true
      end

      it "returns false if user doesn't have an admin role" do
        expect(user.market_maker?).to eq false
      end
    end
  end

  describe "#has_admin_role?" do
    it "returns false if user is not an admin" do
      expect(user.has_admin_role?).to eq false
    end

    it "returns true if user is an admin" do
      user.spree_roles << admin_role
      expect(user.has_admin_role?).to eq true
    end
  end

end
