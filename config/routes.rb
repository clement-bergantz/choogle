Rails.application.routes.draw do
  devise_for :users,
  	controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'pages#home'


  resources :choogles, only: [:new, :create], shallow: true do
  	resources :proposals, only: [:new, :create] do
      resources :proposal_tags, only: [:new, :create]
    end
  	resources :notifications, only: [:new, :create]
  end

  # we create a custom get route based on the slug
  get "/:slug" => "choogles#show", as: :choogle

end

