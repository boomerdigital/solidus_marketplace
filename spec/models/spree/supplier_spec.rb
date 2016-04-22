require 'spec_helper'

describe Spree::Supplier do
  it { is_expected.to belong_to(:address) }

end