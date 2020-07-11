Rails.application.routes.draw do
  root to: 'products#index'

  resources :products, only: [:new, :create, :index] do
    resources :product_backlog_items, only: [:index, :create]
    resource :product_backlog_item_order, only: [:update]
  end

  resources :product_backlog_items, only: [:edit, :update]

  resources :product_backlog_item_estimations, only: [:update]
end
