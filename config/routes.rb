Rails.application.routes.draw do
  root 'simple_pages#index'

  get 'news', to: 'simple_pages#news'
  get 'contacts', to: 'simple_pages#contacts'

  devise_for :users

  resources :portfolios do
    resource :stocks, only: [:new, :create]
  end
  resources :stocks, only: [:edit, :update, :destroy]

end
