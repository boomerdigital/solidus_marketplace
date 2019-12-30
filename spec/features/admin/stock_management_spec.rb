require 'spec_helper'

describe "Stock Management", js: true do

  before do
    @user = create(:supplier_user)
    login_user @user
    visit spree.admin_shipments_path
  end

  context "as supplier user" do

    context "given a product with a variant and a stock location" do
      before do
        @secondary = create(:stock_location, name: 'Secondary', supplier: @user.supplier)
        @product = create(:product, name: 'apache baseball cap', price: 10)
        @v = @product.variants.create!(sku: 'FOOBAR')
        @user.supplier.reload.stock_locations.update_all backorderable_default: false # True database default is false.
      end

      context 'with single variant' do
        before do
          @product.add_supplier! @user.supplier
          @v.stock_items.first.update_column(:count_on_hand, 10)
          @secondary.stock_item(@v).destroy
          click_link "Products"
          sleep(1)
          within '#sidebar-product' do
            click_link "Products"
          end
          click_link @product.name
          within '[data-hook=admin_product_tabs]' do
            click_link "Stock"
          end
        end

        xit "should not show deleted stock_items" do
          within(:css, '.stock_location_info') do
            expect(page).to have_content(@user.supplier.name)
            expect(page).to_not have_content('Secondary')
          end
        end

        xit "can toggle backorderable for a variant's stock item", js: true do
          backorderable = find(".stock_item_backorderable")
          expect(backorderable).to_not be_checked

          backorderable.set(true)

          visit current_path

          backorderable = find(".stock_item_backorderable")
          expect(backorderable).to be_checked
        end

        # Regression test for #2896
        # The regression was that unchecking the last checkbox caused a redirect
        # to happen. By ensuring that we're still on an /admin/products URL, we
        # assert that the redirect is *not* happening.
        xit "can toggle backorderable for the second variant stock item", js: true do
          new_location = create(:stock_location, name: "Another Location", supplier: @user.supplier)
          visit page.current_path

          new_location_backorderable = find "#stock_item_backorderable_#{new_location.id}"
          new_location_backorderable.set(false)
          # Wait for API request to complete.
          sleep(1)

          expect(page.current_url).to include("/admin/products")
        end

        xit "can create a new stock movement", js: true do
          fill_in "stock_movement_quantity", with: 5
          select2 @user.supplier.name, from: "Stock Location"
          click_button "Add Stock"

          expect(page).to have_content('successfully created')
          within(:css, '.stock_location_info table') do
            expect(column_text(2)).to eq '15'
          end
        end

        xit "can create a new negative stock movement", js: true do
          fill_in "stock_movement_quantity", with: -5
          select2 @user.supplier.name, from: "Stock Location"
          click_button "Add Stock"

          expect(page).to have_content('successfully created')

          within(:css, '.stock_location_info table') do
            expect(column_text(2)).to eq '5'
          end
        end

        xit "can create a new negative stock movement", js: true do
          fill_in "stock_movement_quantity", with: -5
          select2 @user.supplier.name, from: "Stock Location"
          click_button "Add Stock"

          expect(page).to have_content('successfully created')

          within(:css, '.stock_location_info table') do
            expect(column_text(2)).to eq '5'
          end
        end
      end

      context "with multiple variants" do
        before do
          v = @product.variants.create!(sku: 'SPREEC')
          @product.add_supplier! @user.supplier
          v.stock_items.first.update_column(:count_on_hand, 30)

          click_link "Products"
          sleep(1)
          within '#sidebar-product' do
            click_link 'Products'
          end
          click_link @product.name
          within '[data-hook=admin_product_tabs]' do
            click_link "Stock"
          end
        end

        xit "can create a new stock movement for the specified variant", js: true do
          fill_in "stock_movement_quantity", with: 10
          select2 "SPREEC", from: "Variant"
          click_button "Add Stock"

          expect(page).to have_content('successfully created')
        end
      end
    end

    # Regression test for #3304
    context "with no stock location" do
      before do
        @product = create(:product, name: 'apache baseball cap', price: 10)
        @product.add_supplier! @user.supplier
        @product.variants.create!(sku: 'FOOBAR')
        Spree::StockLocation.delete_all
        click_link "Products"
        sleep(1)
        within '#sidebar-product' do
          click_link 'Products'
        end
        click_link @product.name
      end

      xit "redirects to stock locations page" do
        expect(page).to have_content(I18n.t('spree.stock_management_requires_a_stock_location'))
        expect(page.current_url).to include("admin/stock_locations")
      end
    end
  end
end
