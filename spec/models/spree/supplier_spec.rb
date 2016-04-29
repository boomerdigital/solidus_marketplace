require 'spec_helper'

describe Spree::Supplier do
  it { is_expected.to belong_to(:address)  }
  it { is_expected.to have_many(:users) }
  it { should callback(:assign_user).after(:create) }



  context '#assign_user' do

    before do
      @instance = build(:supplier)
    end

    it 'with user' do
      dbl=double(Spree.user_class)
      expect(dbl).to_not receive(:find_by_email)
      @instance.email = 'test@test.com'
      @instance.users << create(:user)
      expect{@instance.save}.not_to raise_error
    end

    it 'with existing user email' do
      dbl=double(Spree.user_class)
      user = create(:user, email: 'test@test.com')
      expect(Spree.user_class).to receive(:find_by_email).with(user.email).and_return(user)
      @instance.email = user.email
      @instance.save
      expect(@instance.reload.users.first).to eql(user)
    end

  end
end