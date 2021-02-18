require 'rails_helper'

describe 'Items API' do
  it 'sends all of the items back' do
    create_list(:item, 6)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(items.count).to eq(6)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(String)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_a(Integer)
    end
  end

  describe 'it sends items back within the pagination params supplied' do
    it 'returns items in groups of 20 starting on page 1 by default' do

      create_list(:item, 50)

      get '/api/v1/items'

      first_page_of_items = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(first_page_of_items.count).to eq(20)
      expect(Item.all.count).to eq(50)
      expect(first_page_of_items.first[:id].to_i).to eq((Item.all.min_by { |m| m.id}).id)
    end

    it 'can take parameters related to number of items per page and return page 1 by default' do
      create_list(:item, 50)

      get '/api/v1/items?per_page=5'

      first_page_of_items = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(first_page_of_items.count).to eq(5)
      expect(Item.all.count).to eq(50)
      expect(first_page_of_items.first[:id].to_i).to eq((Item.first.id))
    end

    it 'can return a default of 20 items on a specified page' do
      create_list(:item, 50)

      get '/api/v1/items?page=2'

      last_page_of_items = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(last_page_of_items.count).to eq(20)
      expect(Item.all.count).to eq(50)
      expect(last_page_of_items.first[:id].to_i).to eq((Item.all.min_by { |m| m.id}).id + 20)
    end

    it 'can return a page with a number of results less than the per_page' do
      create_list(:item, 50)

      get '/api/v1/items?page=3'

      last_page_of_items = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(last_page_of_items.count).to eq(10)
      expect(Item.all.count).to eq(50)
      expect(last_page_of_items.last[:id].to_i).to eq((Item.all.max_by { |m| m.id}).id)
    end

    it 'can return a specified number per page and go to the specified page' do
      create_list(:item, 50)

      get '/api/v1/items?per_page=5&page=3'

      third_page_of_items = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(third_page_of_items.count).to eq(5)
      expect(Item.all.count).to eq(50)
      expect(third_page_of_items.first[:id].to_i).to eq((Item.all.min_by { |m| m.id}).id + 10)
    end
  end

  it 'returns one item by its id' do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful

    expect(item).to have_key(:id)
    expect(item[:id].to_i).to eq(id)

    expect(item[:attributes]).to have_key(:name)
    expect(item[:attributes][:name]).to be_a(String)

    expect(item[:attributes]).to have_key(:description)
    expect(item[:attributes][:description]).to be_a(String)

    expect(item[:attributes]).to have_key(:unit_price)
    expect(item[:attributes][:unit_price]).to be_a(Float)
  end
end
