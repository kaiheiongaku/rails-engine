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

  it "can create a new item" do
    merchant = create(:merchant)
    item_params = ({
                    name: 'IT Band',
                    description: 'From Ian and Tim come a band that helps code',
                    unit_price: 7.30,
                    merchant_id: merchant.id,

                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it 'can update an item' do
    id = create(:item).id
    previous_name = Item.last.name
    item_params = { name: "Timmy and Iyan's Band" }
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({ item: item_params })
    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("Timmy and Iyan's Band")
  end

  it 'can destroy an item and invoices with just that item' do
    item = create(:item)

    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
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

      get "/api/v1/items/find_all?name=Ring"

      expect(response).to be_successful

      search_result = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(search_result.map {|m| m[:attributes][:name] }).to eq([@item2.name])
    end

    it 'can return items that most closely match the params in case sensitive alphabetical order (lower case)' do

      get "/api/v1/items/find_all?name=ring"

      expect(response).to be_successful

      search_result = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(search_result.map { |m| m[:attributes][:name] }).to eq([@item3.name, @item4.name, @item1.name])
    end

    it 'can return items that are above a minimum price' do
      get "/api/v1/items/find_all?min_price=5.00"

      expect(response).to be_successful

      search_result = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(search_result.map { |m| m[:attributes][:name] }).to eq([@item2.name, @item4.name])
    end

    it 'can return items below a maximum price' do
      get "/api/v1/items/find_all?max_price=5.00"

      expect(response).to be_successful

      search_result = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(search_result.map { |m| m[:attributes][:name] }).to eq([@item1.name, @item3.name])
    end

    it 'can return items within a range' do
      get "/api/v1/items/find_all?min_price=4.00&max_price=6.00"

      expect(response).to be_successful

      search_result = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(search_result.map { |m| m[:attributes][:name] }).to eq([@item1.name, @item2.name])
    end

    it 'does not allow both name and price range in a search' do

    end
  end
end
