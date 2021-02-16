require 'rails_helper'

describe 'Merchants API' do
  it 'sends all of the merchants back' do
    create_list(:merchant, 6)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants.count).to eq(6)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(Integer)

      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to be_a(String)
    end

    it 'returns one merchant by its id' do
      id = create(:merchant).id

      get "/api/v1/merchants/#{id}"

    end
  end
end
