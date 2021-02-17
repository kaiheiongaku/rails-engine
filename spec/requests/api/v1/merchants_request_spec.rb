require 'rails_helper'

describe 'Merchants API' do
  it 'sends all of the merchants back' do
    create_list(:merchant, 6)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchants.count).to eq(6)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  describe 'it sends merchants back within the pagination params supplied' do
    it 'returns merchants in groups of 20 starting on page 1 by default' do

      create_list(:merchant, 50)

      get '/api/v1/merchants'

      first_page_of_merchants = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(first_page_of_merchants.count).to eq(20)
      expect(Merchant.all.count).to eq(50)
      expect(first_page_of_merchants.first[:id].to_i).to eq((Merchant.all.min_by { |m| m.id}).id)
    end

    it 'can take parameters related to number of merchants per page and return page 1 by default' do
      create_list(:merchant, 50)

      get '/api/v1/merchants?per_page=5'

      first_page_of_merchants = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(first_page_of_merchants.count).to eq(5)
      expect(Merchant.all.count).to eq(50)
      expect(first_page_of_merchants.first[:id].to_i).to eq((Merchant.first.id))
    end

    it 'can return a default of 20 merchants on a specified page' do
      create_list(:merchant, 50)

      get '/api/v1/merchants?page=2'

      last_page_of_merchants = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(last_page_of_merchants.count).to eq(20)
      expect(Merchant.all.count).to eq(50)
      expect(last_page_of_merchants.first[:id].to_i).to eq((Merchant.all.min_by { |m| m.id}).id + 20)
    end

    it 'can return a page with a number of results less than the per_page' do
      create_list(:merchant, 50)

      get '/api/v1/merchants?page=3'

      last_page_of_merchants = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(last_page_of_merchants.count).to eq(10)
      expect(Merchant.all.count).to eq(50)
      expect(last_page_of_merchants.last[:id].to_i).to eq((Merchant.all.max_by { |m| m.id}).id)
    end

    it 'can return a specified number per page and go to the specified page' do
      create_list(:merchant, 50)

      get '/api/v1/merchants?per_page=5&page=3'

      third_page_of_merchants = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(third_page_of_merchants.count).to eq(5)
      expect(Merchant.all.count).to eq(50)
      expect(third_page_of_merchants.first[:id].to_i).to eq((Merchant.all.min_by { |m| m.id}).id + 10)
    end
  end

  it 'returns one merchant by its id' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to eq(id)

    expect(merchant).to have_key(:name)
    expect(merchant[:name]).to be_a(String)
  end
end
