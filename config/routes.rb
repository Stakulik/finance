Rails.application.routes.draw do
  root 'simple_pages#index'

  get 'about', to: 'simple_pages#about'

  devise_for :users
  resource :user

  resources :portfolios do
    resources :stocks, only: [:index, :new, :create]
  end
  resources :stocks, only: [:show, :edit, :update, :destroy]

end
