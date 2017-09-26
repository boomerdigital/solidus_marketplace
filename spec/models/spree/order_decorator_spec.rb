require 'spec_helper'

describe Spree::Order do

  context '#finalize_with_drop_ship!' do

    after do
      SolidusMarketplace::Config[:send_supplier_email] = true
    end

    xit 'should deliver drop ship orders when Spree::DropShipConfig[:send_supplier_email] == true' do
      order = create(:order_with_totals, ship_address: create(:address))
      order.line_items = [create(:line_item, variant: create(:variant_with_supplier)), create(:line_item, variant: create(:variant_with_supplier))]
      order.create_proposed_shipments

      order.shipments.each do |shipment|
        expect(Spree::DropShipOrderMailer).to receive(:supplier_order).with(shipment.id).and_return(double(Mail, :deliver! => true))
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

    it 'should NOT deliver drop ship orders when Spree::DropShipConfig[:send_supplier_email] == false' do
      SolidusMarketplace::Config[:send_supplier_email] = false
      order = create(:order_with_totals, ship_address: create(:address))
      order.line_items = [create(:line_item, variant: create(:variant_with_supplier)), create(:line_item, variant: create(:variant_with_supplier))]
      order.create_proposed_shipments

      order.shipments.each do |shipment|
        expect(Spree::DropShipOrderMailer).not_to receive(:supplier_order).with(shipment.id)
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

end
