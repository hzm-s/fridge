# typed: strict
Rails.application.routes.draw do
  root to: 'products#index'

  get 'sign_in', to: 'sign_in#index', as: :sign_in
  get 'auth/:provider/callback', to: 'oauth_callbacks#create', as: :oauth_callback

  resources :products, only: [:new, :create, :index] do
    resources :product_backlog_items, only: [:index, :create]
    resource :product_backlog_order, only: [:update]
  end

  resources :product_backlog_items, only: [:edit, :update, :destroy] do
    resources :acceptance_criteria, param: :no, only: [:create, :destroy]
  end

  resources :product_backlog_item_estimations, only: [:update]
end
