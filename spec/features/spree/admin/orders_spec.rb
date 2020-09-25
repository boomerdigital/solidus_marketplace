# frozen_string_literal: true

describe 'Admin - Orders', type: :feature do
  let!(:user) { create(:user) }

  it 'Supplier should not be authorized' do
    visit spree.root_path
    click_link 'Login'
    fill_in 'spree_user[email]', with: user.email
    fill_in 'spree_user[password]', with: user.password
    click_button 'Login'
    expect(page).to_not have_content 'Login'

    visit spree.admin_orders_path
    expect(page).to have_content('Authorization Failure')
  end
end
