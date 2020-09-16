# typed: strict
Rails.application.routes.draw do
  root to: 'products#index'

  get 'auth/:provider/callback', to: 'oauth_callbacks#create', as: :oauth_callback
  get 'sign_in', to: 'sessions#new', as: :sign_in
  delete 'sign_out', to: 'sessions#destroy', as: :sign_out

  resources :products, only: [:new, :create, :index] do
    resources :issues, only: [:create]
    resource :plan, only: [:update]
    resources :releases, only: [:new, :create]
  end

  resources :product_backlogs, param: :product_id, only: [:show]

  resources :releases, param: :no, only: [:edit, :update, :destroy]

  resources :pbis, only: [:edit, :update, :destroy] do
    resources :acceptance_criteria, only: [:create]
  end
  resources :acceptance_criteria, only: [:destroy]

  resources :pbi_estimations, only: [:update]
  resources :pbi_developments, only: [:create, :destroy]

  resources :teams, only: [:new, :create, :show] do
    resources :members, only: [:new, :create]
  end
end
