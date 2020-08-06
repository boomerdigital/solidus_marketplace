# frozen_string_literal: true

describe Spree::Supplier do
  it { is_expected.to respond_to(:address) }
  it { is_expected.to respond_to(:products) }
  it { is_expected.to respond_to(:stock_locations) }
  it { is_expected.to respond_to(:variants) }

  it '#deleted?' do
    subject.deleted_at = nil
    expect(subject.deleted_at?).to eql(false)
    subject.deleted_at = Time.now
    expect(subject.deleted_at?).to eql(true)
  end

  context '#create_stock_location' do
    let!(:supplier) { create(:supplier) }

    it 'returns created stock location' do
      expect(Spree::StockLocation.count).to eql(1)
      expect(Spree::StockLocation.active.count).to eql(1)
      expect(Spree::StockLocation.first.country).to eql(supplier.address.country)
      expect(Spree::StockLocation.first.supplier).to eql(supplier)
    end
  end

  context '#send_welcome' do
    let(:supplier) { build(:supplier) }
    let(:mail_message) { double('Mail::Message') }

    context 'with SolidusMarketplace::Config[:send_supplier_email] == false' do
      before do
        SolidusMarketplace::Config.send_supplier_email = false
      end

      it 'should not send' do
        expect {
          expect(Spree::SupplierMailer).to_not receive(:welcome).
            with(an_instance_of(Integer))
        }
      end
    end

    context 'with SolidusMarketplace::Config[:send_supplier_email] == true' do
      before do
        SolidusMarketplace::Config.send_supplier_email = true
      end

      it 'should send welcome email' do
        expect {
          expect(Spree::SupplierMailer).to receive(:welcome).
            with(an_instance_of(Integer))
        }
      end
    end
  end

  context '#set_commission' do
    before do
      SolidusMarketplace::Config.default_commission_flat_rate = 1
      SolidusMarketplace::Config.default_commission_percentage = 1
    end

    it 'returns correct commission values' do
      supplier = create(:supplier)
      # Default configuration is 0.0 for each.
      expect(supplier.commission_flat_rate.to_f).to eql(1.0)
      expect(supplier.commission_percentage.to_f).to eql(10.0)
      # With custom commission applied.
      supplier.update(commission_flat_rate: 123,
                      commission_percentage: 25)
      expect(supplier.commission_flat_rate).to eql(123.0)
      expect(supplier.commission_percentage).to eql(25.0)
    end
  end

  context '#shipments' do
    let!(:supplier) { create(:supplier) }
    let(:stock_location_1){ supplier.stock_locations.first }
    let(:stock_location_2){ create(:stock_location, supplier: supplier) }
    let(:shipment_1){ create(:shipment) }
    let(:shipment_2){ create(:shipment, stock_location: stock_location_1) }
    let(:shipment_3){ create(:shipment) }
    let(:shipment_4){ create(:shipment, stock_location: stock_location_2) }
    let(:shipment_5){ create(:shipment) }
    let(:shipment_6){ create(:shipment, stock_location: stock_location_1) }

    it 'should return shipments for suppliers stock locations' do
      expect(supplier.shipments).
        to match_array([shipment_2, shipment_4, shipment_6])
    end
  end
end
