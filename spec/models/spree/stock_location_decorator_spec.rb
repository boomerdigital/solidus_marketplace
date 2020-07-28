# frozen_string_literal: true

describe Spree::StockLocation do
  it { is_expected.to respond_to(:supplier) }

  subject { create(:stock_location, backorderable_default: true) }

  context 'propagate variants' do
    let(:variant) { build(:variant) }
    let(:stock_item) { subject.propagate_variant(variant) }

    context 'passes backorderable default config' do
      context 'true' do
        before { subject.backorderable_default = true }
        xit { expect(stock_item.backorderable).to eq true }
      end

      context 'false' do
        before { subject.backorderable_default = false }
        xit { expect(stock_item.backorderable).to eq false }
      end
    end

    context 'does not propagate for non supplier variants' do
      before { subject.supplier_id = create(:supplier).id }
      it { expect(stock_item).to be_nil }
    end
  end
end
