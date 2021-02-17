require 'rails_helper'

describe MerchantsFacade do
  it 'returns merchants in groups of 20 starting on page 1 by default' do
    create_list(:merchant, 50)

    merchants = MerchantsFacade.paginate
    expect(merchants.count).to eq(20)
    expect(merchants.min_by {|m| m.id}).to eq(Merchant.all.min_by {|m| m.id})
  end
end
