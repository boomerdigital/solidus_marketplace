require 'spec_helper'

describe Spree::Product do

  let(:product) { create :product }

  it '#supplier?' do
    expect(product.supplier?).to eq false
    product.add_supplier! create(:supplier)
    expect(product.reload.supplier?).to eq true
  end

end
