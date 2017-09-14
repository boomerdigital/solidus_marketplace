require 'spec_helper'

describe Spree.user_class do

  it { should belong_to(:supplier) }

  it { should have_many(:variants).through(:supplier) }

  let(:user) { build :user }

  it '#supplier?' do
    expect(user.supplier?).to eq false
    user.supplier = build :supplier
    expect(user.supplier?).to eq true
  end

end
