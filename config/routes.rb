# typed: false
Rails.application.routes.draw do
  root to: 'products#index'

  get 'auth/:provider/callback', to: 'oauth_callbacks#create', as: :oauth_callback
  get 'sign_in', to: 'sessions#new', as: :sign_in
  delete 'sign_out', to: 'sessions#destroy', as: :sign_out

  resources :product_backlogs, param: :product_id, only: [:show, :update]

  resources :products, only: [:new, :create, :index] do
    resources :pbis, only: [:create]
    resources :releases, param: :number, only: [:new, :create, :edit, :update, :destroy]
    resource :plan, only: [:update]
  end

  resources :issues, only: [:edit, :update, :destroy] do
    resources :acceptance_criteria, param: :number, only: [:create, :update, :destroy]
    resource :acceptance, only: [:show, :update]
    resources :satisfied_acceptance_criteria, param: :number, only: [:create, :destroy]
  end

  resources :feature_estimations, only: [:update]

  resources :sprints, only: [:new, :create]
  resources :sprint_backlogs, param: :product_id, only: [:show]

  scope 'current_sprint/:product_id', as: :current_sprint, module: :current_sprint do
    resources :issues, only: [:create, :destroy]
    resource :work_priority, only: [:update]
  end

  scope 'works/:issue_id', as: :work do
    resources :tasks, param: :number, only: [:create, :update, :destroy]
    resources :task_statuses, param: :number, only: [:update]
    resources :start_tasks, param: :number, only: [:create]
    resources :complete_tasks, param: :number, only: [:create]
    resources :suspend_tasks, param: :number, only: [:create]
    resources :resume_tasks, param: :number, only: [:create]
  end

  resources :teams, only: [:show] do
    resources :members, only: [:new, :create]
  end

  # util
  resource :data, only: [:show] do
    resource :export, only: [:new, :create]
    resource :import, only: [:new, :create]
  end

  # for demo
  get '___bd___', to: 'bd#index'
  post 'bd_sign_in/:ua_id', to: 'bd#create'
end
