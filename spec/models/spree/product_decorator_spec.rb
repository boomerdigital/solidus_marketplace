# frozen_string_literal: true

describe Spree::Product do
  let!(:product) { create(:product) }
  let(:supplier1) { create(:supplier) }
  let(:supplier2) { create(:supplier) }

  describe '#add_supplier!' do
    context 'when passed a supplier' do
      it "adds the supplier to product's list of supppliers" do
        expect(product.suppliers).to be_empty
        product.add_supplier!(supplier1)
        expect(product.reload.suppliers).to include(supplier1)
      end
    end

    context 'when passed a supplier_id' do
      it "adds the supplier to product's list of supppliers" do
        expect(product.suppliers).to be_empty
        product.add_supplier!(supplier2.id)
        expect(product.reload.suppliers).to include(supplier2)
      end
    end
  end

  describe '#add_suppliers!' do
    it "adds multiple suppliers to the product's list of suppliers" do
      expect(product.suppliers).to be_empty
      product.add_suppliers!([supplier1.id, supplier2.id])
      expect(product.reload.suppliers).to include(supplier1)
      expect(product.reload.suppliers).to include(supplier2)
    end
  end

  describe '#remove_suppliers!' do
    it "removes multiple suppliers from the product's list of suppliers" do
      product.add_suppliers!([supplier1.id, supplier2.id])
      expect(product.reload.suppliers).to include(supplier1)
      expect(product.reload.suppliers).to include(supplier2)

      product.remove_suppliers!([supplier1.id, supplier2.id])
      expect(product.suppliers).to be_empty
    end
  end

  describe '#supplier?' do
    it 'returns true if one or more suppliers are present' do
      expect(product.supplier?).to eq false
      product.add_supplier!(create(:supplier))
      expect(product.reload.supplier?).to eq true
    end
  end
end
