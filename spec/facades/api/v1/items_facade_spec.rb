require 'rails_helper'

describe ItemsFacade do
  describe 'pagination' do
    before :each do
      create_list(:item, 50)
    end

    it 'returns items in groups of 20 starting on page 1 by default' do
      items = ItemsFacade.paginate
      expect(items.count).to eq(20)
      expect(items.first).to be_a(Item)
      expect(items.min_by {|m| m.id}).to eq(Item.all.min_by {|m| m.id})
    end

    it 'returns items using a custom number per page on default page 1' do
      items = ItemsFacade.paginate(per_page: 5)
      expect(items.count).to eq(5)
      expect(items.first).to be_a(Item)
      expect(items.first.id).to eq((Item.all.min_by {|m| m.id}).id)
    end

    it 'returns items using a custom page number with default 20 items' do
      items = ItemsFacade.paginate(page: 2)
      expect(items.count).to eq(20)
      expect(items.first).to be_a(Item)
      expect(items.first.id).to eq((Item.all.min_by {|m| m.id}).id + 20)
    end

    it 'returns items with a custom per page and page number' do
      items = ItemsFacade.paginate(page: 3, per_page: 3)
      expect(items.count).to eq(3)
      expect(items.first).to be_a(Item)
      expect(items.first.id).to eq((Item.all.min_by {|m| m.id}).id + 6)
    end
  end

  describe 'item search' do
    before :each do
      @merchant = Merchant.create!(name: "Theodore Franklin and Sons")
      @item1 = Item.create!(name: "Turing", description: "Terribly Terrific", unit_price: 4.99, merchant_id: @merchant.id)
      @item2 = Item.create!(name: "Rings Ding Ding", description: 'Awww', unit_price: 5.25, merchant_id: @merchant.id)
      @item3 = Item.create!(name: "Aring", description: 'Uhhh', unit_price: 3.99, merchant_id: @merchant.id)
      @item4 = Item.create!(name: "Sliverings", description: 'Unsure', unit_price: 10.99, merchant_id: @merchant.id)
    end

    it 'can return items that most closely match the params in case sensitive alphabetical order (upper case)' do
      expect(ItemsFacade.search("Ring", nil, nil)).to eq([@item2])
    end

    it 'can return items that most closely match the params in case sensitive alphabetical order (lower case)' do
      expect(ItemsFacade.search('ring', nil, nil)).to eq([@item3, @item4, @item1])
    end

    it 'can return items that are above a minimum price' do
      expect(ItemsFacade.search(nil, 5.00, nil)).to eq([@item2, @item4])
    end

    it 'can return items below a maximum price' do
      expect(ItemsFacade.search(nil, nil, 5.00)).to eq([@item1, @item3])
    end

    it 'can return items within a range of prices' do
      expect(ItemsFacade.search(nil, 4.00, 6.00)).to eq([@item1, @item2])
    end
  end
end
