Rails.application.routes.draw do
  resources :product_backlog_items, only: [:create, :index]
end
