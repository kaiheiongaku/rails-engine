Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get "/merchants/find_one", to: 'merchant_search#show'
      get "/merchants/most_revenue", to: 'merchant_revenues#index'
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], :controller => 'merchant_items'
      end
      get "/items/find_all", to: "items_search#index"
      resources :items, only: [:index, :show, :create, :update, :destroy] do
        resources :merchant, only: [:index], :controller => 'item_merchant'
      end
    end
  end
end
