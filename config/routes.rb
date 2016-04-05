Rails.application.routes.draw do

  root 'simple_pages#index'

  get 'about', to: 'simple_pages#about'

  devise_for :users
  resource :user

  resources :portfolios do
    resource :stocks, only: [:new, :create]
  end
  resources :stocks, only: [:edit, :update, :destroy]

end
