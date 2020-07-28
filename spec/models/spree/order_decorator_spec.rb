# frozen_string_literal: true

describe Spree::Order do
  let!(:order) do
    order = create(:order_with_totals)
    order.line_items = [create(:line_item,
                               variant: create(:variant_with_supplier)),
                        create(:line_item,
                               variant: create(:variant_with_supplier))]
    order.create_proposed_shipments
    order
  end

  context '#finalize_with_supplier!' do
    after do
      SolidusMarketplace::Config.send_supplier_email = true
    end

    xit 'should deliver marketplace orders when SolidusMarketplace::Config[:send_supplier_email] == true' do
      order.shipments.each do |shipment|
        expect(Spree::MarketplaceOrderMailer).to receive(:supplier_order).with(shipment.id).and_return(double(Mail, :deliver! => true))
      end

      order.finalize!
      order.reload

      # Check orders are properly split.
      expect(order.shipments.size).to eql(2)
      order.shipments.each do |shipment|
        expect(shipment.line_items.size).to eql(1)
        expect(shipment.line_items.first.variant.suppliers.first).to eql(shipment.supplier)
      end
    end

    xit 'should NOT deliver marketplace orders when SolidusMarketplace::Config[:send_supplier_email] == false' do
      SolidusMarketplace::Config.send_supplier_email = false

      order.shipments.each do |shipment|
        expect(Spree::MarketplaceOrderMailer).not_to receive(:supplier_order).with(shipment.id)
      end

      order.finalize!
      order.reload

      # Check orders are properly split.
      expect(order.shipments.size).to eql(2)
      order.shipments.each do |shipment|
        expect(shipment.line_items.size).to eql(1)
        expect(shipment.line_items.first.variant.suppliers.first).to eql(shipment.supplier)
      end
    end
  end

  xdescribe '#supplier_total' do
    let!(:order) { create(:completed_order_from_supplier_with_totals,
                          ship_address: create(:address)) }
    let(:supplier) { order.suppliers.first }
    let(:expected_supplier_total) { Spree::Money.new(15.00) }

    context 'when passed a supplier' do
      it 'returns the total commission earned for the order for a given supplier' do
        expect(order.total).to eq(150.0)
        expect(order.suppliers.count).to eq(1)
        expect(order.supplier_total(supplier).to_s).to eq(expected_supplier_total.to_s)
      end
    end

    context 'when passed a user associated with a supplier' do
      it 'returns the total commission earned for the order for a given supplier' do
        expect(order.total).to eq(150.0)
        expect(order.suppliers.count).to eq(1)
        expect(order.supplier_total(supplier)).to eq(expected_supplier_total)
      end
    end
  end
end
