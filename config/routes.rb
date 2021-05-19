# typed: false
Rails.application.routes.draw do
  root to: 'products#index'

  get 'auth/:provider/callback', to: 'oauth_callbacks#create', as: :oauth_callback
  get 'sign_in', to: 'sessions#new', as: :sign_in
  delete 'sign_out', to: 'sessions#destroy', as: :sign_out

  resources :product_backlogs, param: :product_id, only: [:show, :update]

  resources :products, only: [:new, :create, :index] do
    resources :issues, only: [:create]
    resources :releases, param: :number, only: [:new, :create, :edit, :update, :destroy]
    resource :plan, only: [:update]
  end

  resources :issues, only: [:edit, :update, :destroy] do
    resources :acceptance_criteria, only: [:create]
  end
  resources :acceptance_criteria, only: [:destroy]

  resources :feature_estimations, only: [:update]

  resources :sprints, only: [:new, :create]
  resources :sprint_backlogs, param: :product_id, only: [:show]

  scope 'current_sprint/:product_id', as: :current_sprint, module: :current_sprint do
    resources :issues, only: [:create]
  end

  scope 'works/:issue_id', as: :work do
    resources :tasks, only: [:create]
  end

  resources :teams, only: [:show] do
    resources :members, only: [:new, :create]
  end
end
