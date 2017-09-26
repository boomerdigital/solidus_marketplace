require 'spec_helper'

describe Spree.user_class do

  it { should belong_to(:supplier) }

  it { should have_many(:variants).through(:supplier) }

  let(:user) { build :user }

  describe '#supplier?' do
    it "returns true if user is a supplier" do
      user.supplier = build :supplier
      expect(user.supplier?).to eq true
    end

    it "returns false if user is not a supplier" do
      expect(user.supplier?).to eq false
    end
  end

  describe "#has_admin_role?" do
    it "returns true if user is an admin"
  end

end
