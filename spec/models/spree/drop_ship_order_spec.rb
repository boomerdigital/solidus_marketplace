require 'spec_helper'

describe Spree::DropShipOrder do

  it { should belong_to(:order) }
  it { should belong_to(:supplier) }

  it { should have_many(:drop_ship_line_items).dependent(:destroy) }
  it { should have_many(:line_items).through(:drop_ship_line_items) }
  it { should have_many(:users).through(:supplier) }

  it { should have_one(:user) }

  it { should validate_presence_of(:commission) }
  it { should validate_presence_of(:order_id) }
  it { should validate_presence_of(:supplier_id) }

  it '#currency' do
    record = create(:drop_ship_order)
    record.currency.should eql(record.order.currency)
  end

  it '#destroy' do
    instance = create(:drop_ship_order)
    instance.destroy.should eql(false)
  end

  it '#display_total' do
    record = create(:order_for_drop_ship).drop_ship_orders.first
    record.display_total.should == Spree::Money.new(50.0)
  end

  it '#number' do
    record = create(:drop_ship_order)
    record.number.should eql(record.id)
  end

  it '#shipment_state' do
    pending 'write or remove'
    record = create(:drop_ship_order)
    record.shipment_state.should eql(record.order.currency)
  end

  it '#shipments' do
    pending 'write it'
  end

  it '#total' do
    record = create(:order_for_drop_ship).drop_ship_orders.first
    record.total.to_f.should eql(50.0)
  end

  context "A new drop ship order" do

    it "should calcluate total when empty" do
      @drop_ship_order = build(:drop_ship_order)
      assert_equal 0.0, @drop_ship_order.send(:update_total)
    end

  end

  context "A suppliers active drop ship order" do

    before do
      @supplier = create(:supplier)
      @drop_ship_order = create(:drop_ship_order, supplier: @supplier)
      @supplier.orders << @drop_ship_order
    end

    it "should add line relevant line items" do
      suppliers_item = create(:line_item, variant: create(:variant_with_supplier, product: create(:product, supplier: @supplier)))
      @line_items = [ create(:line_item), create(:line_item, variant: create(:variant_with_supplier)), suppliers_item ]
      @drop_ship_order.add(@line_items)
      assert_equal 1, @drop_ship_order.line_items.count
    end

  end

  context "A drop ship order's state machine" do

    before do
      ActionMailer::Base.deliveries = []
      @drop_ship_order = create(:drop_ship_order)
      @drop_ship_order.order.ship_address = create(:address)
      @drop_ship_order.save
    end

    it "should start in the 'active' state" do
      assert_equal "active", @drop_ship_order.state
    end

    context "when delivered" do

      context 'with DropShopConfig[:send_supplier_email] == false' do
        after do
          Spree::DropShipConfig.set send_supplier_email: true
          ActionMailer::Base.deliveries = []
        end
        before do
          Spree::DropShipConfig.set send_supplier_email: false
          ActionMailer::Base.deliveries = []
          @drop_ship_order.deliver!
        end
        it 'should not deliver mail' do
          ActionMailer::Base.deliveries.size.should eql(0)
        end
      end

      context 'with DropShopConfig[:send_supplier_email] == true (default)' do

        before do
          @drop_ship_order.deliver!
        end

        it "should move to the 'sent' state" do
          assert_equal "sent", @drop_ship_order.state
        end

        it "should set sent at" do
          assert_not_nil @drop_ship_order.sent_at
        end

        it "should send order to supplier" do
          assert_equal @drop_ship_order.supplier.email, ActionMailer::Base.deliveries.last.to.first
          assert_equal "#{Spree::Config[:site_name]} Drop Ship Order ##{@drop_ship_order.id}", ActionMailer::Base.deliveries.last.subject
        end

      end

      context "and confirmed" do

        before do
          @drop_ship_order.deliver!
          @drop_ship_order.confirm!
        end

        it "should move to the 'confirmed' state" do
          assert_equal "confirmed", @drop_ship_order.state
        end

        it "should set confirmed at" do
          assert_not_nil @drop_ship_order.confirmed_at
        end

        context "and completed" do

          before do
            @drop_ship_order.complete!
          end

          it "should move to the 'complete' state" do
            assert_equal "completed", @drop_ship_order.state
          end

          it "should set completed at" do
            assert_not_nil @drop_ship_order.completed_at
          end

        end

      end

    end

  end

  it '#update_commission' do
    record = create(:drop_ship_order)
    record.supplier.stub commission_flat_rate: 0.3
    record.supplier.stub commission_percentage: 10
    record.stub total: 110
    record.save
    record.reload.commission.to_f.should eql(11.3)
  end

end