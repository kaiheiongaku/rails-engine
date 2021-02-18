require 'rails_helper'

describe ItemsFacade do
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
