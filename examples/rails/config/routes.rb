Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#index'

  get 'show/:uuid', to: 'application#show', as: 'show'
  post 'create_order/:uuid', to: 'application#create_order', as: 'create_order'
  get 'create_order_completed', to: 'application#create_order_completed', as: 'create_order_completed'
  get 'create_order_error', to: 'application#create_order_error', as: 'create_order_error'
end
