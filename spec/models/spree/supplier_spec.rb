require 'spec_helper'
require 'shoulda-matchers'

describe Spree::Supplier do
  it { is_expected.to belong_to(:address)  }

end