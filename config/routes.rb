Rails.application.routes.draw do
  devise_for :users,
  	controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'pages#home'

  resources :choogles, only: [:new, :create, :show], shallow: true do 
  	resources :proposals, only: [:new, :create]
  	resources :notifications, only: [:new, :create]
  end
end
