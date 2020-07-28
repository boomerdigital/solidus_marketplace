# frozen_string_literal: true

describe Spree::Shipment do
  context 'Scopes' do
    let!(:supplier) { create(:supplier) }
    let(:stock_location_1) { supplier.stock_locations.first }
    let(:stock_location_2) { create(:stock_location, supplier: supplier) }
    let(:shipment_1) { create(:shipment) }
    let(:shipment_2) { create(:shipment, stock_location: stock_location_1) }
    let(:shipment_3) { create(:shipment) }
    let(:shipment_4) { create(:shipment, stock_location: stock_location_2) }
    let(:shipment_5) { create(:shipment) }
    let(:shipment_6) { create(:shipment, stock_location: stock_location_1) }

    it '#by_supplier' do
      expect(subject.class.by_supplier(supplier.id)).
        to match_array([shipment_2, shipment_4, shipment_6])
    end
  end

  context '#after_ship' do
    let(:supplier) { create(:supplier_with_commission) }
    let(:shipment) { create(:shipment, stock_location: supplier.stock_locations.first) }

    it 'should capture payment if balance due' do
      skip 'TODO make it so!'
    end

    xit 'should track commission for shipment' do
      expect(shipment.supplier_commission.to_f).to eql(0.0)
      allow(shipment).to receive(:final_price_with_items).and_return(10.0)
      shipment.send(:after_ship)
      expect(shipment.reload.supplier_commission.to_f).to eql(1.5)
    end
  end

  context '#final_price_with_items' do
    let(:shipment) { build(:shipment) }

    it 'returns correct prices' do
      allow(shipment).to receive(:item_cost).and_return(50.0)
      allow(shipment).to receive(:final_price).and_return(5.5)
      expect(shipment.final_price_with_items.to_f).to eql(55.5)
    end
  end
end
