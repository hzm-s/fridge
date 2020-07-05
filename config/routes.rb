Rails.application.routes.draw do
  root to: 'products#index'

  resources :products, only: [:index]
  resources :product_backlog_items, only: [:index, :create, :edit, :update]
  resources :product_backlog_item_estimations, only: [:update]
end
