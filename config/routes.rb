Rails.application.routes.draw do
  root to: 'products#index'

  resources :products, only: [:index]
  resources :product_backlog_items, only: [:index, :new, :create]
end
