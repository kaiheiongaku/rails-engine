require 'rails_helper'

describe MerchantsFacade do
  describe 'returns merchants' do
    before :each do
      create_list(:merchant, 50)
    end

    it 'returns merchants in groups of 20 starting on page 1 by default' do
      merchants = MerchantsFacade.paginate
      expect(merchants.count).to eq(20)
      expect(merchants.first).to be_a(Merchant)
      expect(merchants.min_by {|m| m.id}).to eq(Merchant.all.min_by {|m| m.id})
    end

    it 'returns merchants using a custom number per page on default page 1' do
      merchants = MerchantsFacade.paginate(per_page: 5)
      expect(merchants.count).to eq(5)
      expect(merchants.first).to be_a(Merchant)
      expect(merchants.first.id).to eq((Merchant.all.min_by {|m| m.id}).id)
    end

    it 'returns merchants using a custom page number with default 20 merchants' do
      merchants = MerchantsFacade.paginate(page: 2)
      expect(merchants.count).to eq(20)
      expect(merchants.first).to be_a(Merchant)
      expect(merchants.first.id).to eq((Merchant.all.min_by {|m| m.id}).id + 20)
    end

    it 'returns merchants with a custom per page and page number' do
      merchants = MerchantsFacade.paginate(page: 3, per_page: 3)
      expect(merchants.count).to eq(3)
      expect(merchants.first).to be_a(Merchant)
      expect(merchants.first.id).to eq((Merchant.all.min_by {|m| m.id}).id + 6)
    end
  end

  describe 'returns specific merchant based off of search' do
    before :each do
      @merchant = Merchant.create(name: "Turing")
      @merchant2 = Merchant.create(name: "Rings of Gold")
      @merchant3 = Merchant.create(name: "Silverings")
      @merchant4 = Merchant.create(name: "Tail-o-Ring")
    end

    it 'can return one merchant who most closely matches the params in case sensitive alphabetical order (upper case)' do
      expect(MerchantsFacade.search("Ring")).to eq(@merchant2)
    end

    it 'can return one merchant who most closely matches the params in case sensitive alphabetical order (upper case)' do
      expect(MerchantsFacade.search("ring")).to eq(@merchant3)
    end
  end
end
