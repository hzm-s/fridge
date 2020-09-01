# typed: strict
Rails.application.routes.draw do
  root to: 'products#index'

  resource :home, only: [:show]

  get 'auth/:provider/callback', to: 'oauth_callbacks#create', as: :oauth_callback
  get 'sign_in', to: 'sessions#new', as: :sign_in
  delete 'sign_out', to: 'sessions#destroy', as: :sign_out

  resources :products, only: [:new, :create, :index] do
    resources :pbis, only: [:index, :create]
    resource :plan, only: [:update]
    resources :releases, only: [:new, :create]
    resources :team_members, only: [:index, :new, :create]
  end

  resources :releases, param: :no, only: [:edit, :update, :destroy]

  resources :pbis, only: [:edit, :update, :destroy] do
    resources :acceptance_criteria, only: [:create]
  end
  resources :acceptance_criteria, only: [:destroy]

  resources :pbi_estimations, only: [:update]
  resources :pbi_developments, only: [:create, :destroy]

  resources :teams, only: [:new, :create]
end
