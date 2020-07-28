# frozen_string_literal: true

describe 'Admin - Products', type: :feature, js: true do
  let(:supplier1) { create(:supplier) }
  let(:supplier2) { create(:supplier) }
  let(:product) do
    product = create(:product)
    product.add_supplier!(supplier1)
    product
  end

  context 'as Admin' do
    xit 'should be able to change supplier' do
      login_user create(:admin_user)
      visit spree.admin_product_path(product)

      select2 s2.name, from: 'Supplier'
      click_button 'Update'

      expect(page).to have_content("Product \"#{product.name}\" has been successfully updated!")
      expect(product.reload.suppliers.first.id).to eql(s2.id)
    end
  end
end
