# frozen_string_literal: true

describe 'Admin - Marketplace Settings', type: :feature do
  let!(:user) { create(:admin_user) }

  before do
    visit spree.admin_path
    within '[data-hook=admin_tabs]' do
      click_link 'Settings'
    end
    within 'ul[data-hook=admin_configurations_sidebar_menu]' do
      click_link 'Marketplace Settings'
    end
  end

  xit 'should be able to be updated' do
    # Change settings
    uncheck 'send_supplier_email'
    fill_in 'default_commission_flat_rate', with: 0.30
    fill_in 'default_commission_percentage', with: 10
    click_button 'Update'
    expect(page).to have_content('Marketplace settings successfully updated.')

    # Verify update saved properly by reversing checkboxes or checking field values.
    check 'send_supplier_email'
    click_button 'Update'
    expect(find_field('default_commission_flat_rate').value.to_f).to eql(0.3)
    expect(find_field('default_commission_percentage').value.to_f).to eql(10.0)
    expect(page).to have_content('Marketplace settings successfully updated.')
  end
end
