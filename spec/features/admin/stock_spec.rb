require 'spec_helper'

feature 'Admin - Product Stock Management', js: true do

  before do
    @user = create(:supplier_user)
    @supplier1 = @user.supplier
    @supplier2 = create(:supplier)
    @product = create :product
    @product.add_supplier! @supplier1
  end

  context 'as Admin' do

    scenario 'should display all existing stock item locations' do
      login_user create(:admin_user)
      visit spree.stock_admin_product_path(@product)

      within '.stock_location_info' do
        expect(page).to have_content(@supplier1.name)
        # Stock item doesn't exist
        expect(page).to_not have_content(@supplier2.name)
      end
    end

  end

  context 'as Supplier' do

    before(:each) do
      login_user @user
      visit '/admin/products'
      click_link "Stock Locations"
    end

    scenario 'should only display suppliers stock locations' do
      visit spree.stock_admin_product_path(@product)

      within '.stock_location_info' do
        expect(page).to have_content(@supplier1.name)
        expect(page).to_not have_content(@supplier2.name)
      end
    end

    scenario "can create a new stock location" do
      visit spree.new_admin_stock_location_path
      fill_in "Name", with: "London"
      check "Active"
      click_button "Create"

      expect(page).to have_content("successfully created")
      expect(page).to have_content("London")
    end

    scenario "can delete an existing stock location", js: true do
      create(:stock_location, supplier: @user.supplier)
      visit current_path

      expect(find('#listing_stock_locations')).to have_content("NY Warehouse")
      within_row(2) { click_icon :delete }
      page.driver.browser.switch_to.alert.accept
      # Wait for API request to complete.
      sleep(1)
      visit current_path

      expect(find('#listing_stock_locations')).to_not have_content("NY Warehouse")
    end

    scenario "can update an existing stock location" do
      create(:stock_location, supplier: @user.supplier)
      visit current_path

      expect(page).to have_content("Big Store")

      within_row(1) { click_icon :edit }
      fill_in "Name", with: "London"
      click_button "Update"

      expexct(page).to have_content("successfully updated")
      expect(page).to have_content("London")
    end

    scenario "can deactivate an existing stock location" do
      create(:stock_location, supplier: @user.supplier)
      visit current_path

      expect(page).to have_content("Big Store")

      within_row(1) { click_icon :edit }
      uncheck "Active"
      click_button "Update"

      expect(find('#listing_stock_locations')).to have_content("Inactive")
    end

  end

end
