require 'rails_helper'

describe 'find the merchant for an item' do
  it 'returns the merchant assocated with an item' do
    merchant_creation = create(:merchant)
    item = create(:item, merchant: merchant_creation)

    get "/api/v1/items/#{item.id}/merchant"

    expect(response).to be_successful
    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchant[:attributes][:name]).to eq(merchant_creation.name)
    expect(merchant[:id].to_i).to eq(merchant_creation.id)
  end
end
