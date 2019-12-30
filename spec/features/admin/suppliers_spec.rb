require 'spec_helper'

feature 'Admin - Suppliers', js: true do

  before do
    country = create(:country, name: "United States")
    create(:state, name: "Vermont", country: country)
    @supplier = create :supplier
  end

  context 'as an MarketMaker (aka admin)' do

    before do
      login_user create(:admin_user)
      visit spree.admin_path
      within '[data-hook=admin_tabs]' do
        click_link 'Suppliers'
      end
      expect(page).to have_content('Suppliers')
    end

    xscenario 'should be able to create new supplier' do
      click_link 'New Supplier'
      check 'supplier_active'
      fill_in 'supplier[name]', with: 'Test Supplier'
      fill_in 'supplier[email]', with: 'spree@example.com'
      fill_in 'supplier[url]', with: 'http://www.test.com'
      fill_in 'supplier[commission_flat_rate]', with: '0'
      fill_in 'supplier[commission_percentage]', with: '0'
      fill_in 'supplier[address_attributes][firstname]', with: 'First'
      fill_in 'supplier[address_attributes][lastname]', with: 'Last'
      fill_in 'supplier[address_attributes][address1]', with: '1 Test Drive'
      fill_in 'supplier[address_attributes][city]', with: 'Test City'
      fill_in 'supplier[address_attributes][zipcode]', with: '55555'
      select2 'United States of America', from: 'Country'
      select2 'Vermont', from: 'State'
      fill_in 'supplier[address_attributes][phone]', with: '555-555-5555'
      click_button 'Create'
      expect(page).to have_content('Supplier "Test Supplier" has been successfully created!')
    end

    xscenario 'should be able to delete supplier' do
      click_icon 'delete'
      page.driver.browser.switch_to.alert.accept
      within 'table' do
        expect(page).to_not have_content(@supplier.name)
      end
    end

    xscenario 'should be able to edit supplier' do
      click_icon 'edit'
      check 'supplier_active'
      fill_in 'supplier[name]', with: 'Test Supplier'
      fill_in 'supplier[email]', with: 'spree@example.com'
      fill_in 'supplier[url]', with: 'http://www.test.com'
      fill_in 'supplier[commission_flat_rate]', with: '0'
      fill_in 'supplier[commission_percentage]', with: '0'
      fill_in 'supplier[address_attributes][firstname]', with: 'First'
      fill_in 'supplier[address_attributes][lastname]', with: 'Last'
      fill_in 'supplier[address_attributes][address1]', with: '1 Test Drive'
      fill_in 'supplier[address_attributes][city]', with: 'Test City'
      fill_in 'supplier[address_attributes][zipcode]', with: '55555'
      select2 'United States', from: 'Country'
      select2 'Vermont', from: 'State'
      fill_in 'supplier[address_attributes][phone]', with: '555-555-5555'
      click_button 'Update'
      expect(page).to have_content('Supplier "Test Supplier" has been successfully updated!')
    end

  end

  context 'as a Supplier' do
    before do
      @user = create(:supplier_admin)
      login_user @user
      visit spree.edit_admin_supplier_path(@user.supplier)
    end

    scenario 'should only see tabs they have access to' do
      within '[data-hook=admin_tabs]' do
        expect(page).to have_link('Products')
        expect(page).to have_link('Stock')
        expect(page).to have_link('Stock Locations')
        expect(page).to have_link('Profile')
        expect(page).to have_link('Orders')
        expect(page).to have_link('Suppliers')

        expect(page).to_not have_link('Overview')
        expect(page).to_not have_link('Configuration')
        expect(page).to_not have_link('Promotions')
      end
    end

    xscenario 'should be able to update supplier' do
      fill_in 'supplier[name]', with: 'Test Supplier'
      fill_in 'supplier[email]', with: @user.email
      fill_in 'supplier[url]', with: 'http://www.test.com'
      fill_in 'supplier[address_attributes][firstname]', with: 'First'
      fill_in 'supplier[address_attributes][lastname]', with: 'Last'
      fill_in 'supplier[address_attributes][address1]', with: '1 Test Drive'
      fill_in 'supplier[address_attributes][city]', with: 'Test City'
      fill_in 'supplier[address_attributes][zipcode]', with: '55555'
      select2 'United States', from: 'Country'
      select2 'Vermont', from: 'State'
      fill_in 'supplier[address_attributes][phone]', with: '555-555-5555'
      expect(page).to_not have_css('#supplier_active') # cannot edit active
      expect(page).to_not have_css('#supplier_featured') # cannot edit featured
      expect(page).to_not have_css('#s2id_supplier_user_ids') # cannot edit assigned users
      expect(page).to_not have_css('#supplier_commission_flat_rate') # cannot edit flat rate commission
      expect(page).to_not have_css('#supplier_commission_percentage') # cannot edit comission percentage
      click_button 'Update'
      expect(page).to have_content('Supplier "Test Supplier" has been successfully updated!')
      expect(page.current_path).to eql(spree.edit_admin_supplier_path(@user.reload.supplier))
    end

  end

  context 'as a User other than the suppliers' do

    scenario 'should be unauthorized' do
      supplier = create(:supplier)
      login_user create(:user)
      visit spree.edit_admin_supplier_path(supplier)
      expect(page).to have_content('Authorization Failure')
    end

  end

end
