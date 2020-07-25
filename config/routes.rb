# typed: strict
Rails.application.routes.draw do
  root to: 'products#index'

  get 'auth/:provider/callback', to: 'oauth_callbacks#create', as: :oauth_callback
  get 'sign_in', to: 'sessions#new', as: :sign_in
  delete 'sign_out', to: 'sessions#destroy', as: :sign_out

  resources :invitations, only: [:show]

  resources :products, only: [:new, :create, :index] do
    resources :product_backlog_items, only: [:index, :create]
    resource :product_backlog_order, only: [:update]
    resources :team_members, only: [:index, :new, :create]
  end

  resources :product_backlog_items, only: [:edit, :update, :destroy] do
    resources :acceptance_criteria, param: :no, only: [:create, :destroy]
  end

  resources :product_backlog_item_estimations, only: [:update]
end
