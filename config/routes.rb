Rails.application.routes.draw do

  # custom path to sign_up/registration
  get "users/sign_up" => "registrations#new", as: "new_user_registration"
  patch "/registrations" => "registrations#create", as: "create_registration"

  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root to: 'pages#home'
  # needed for Action Cable WS
  mount ActionCable.server, at: '/cable'

  resources :choogles, only: [:create]

  get '/tag_color' => "tags#tag_color"

  get "/:slug" => "choogles#show", as: :choogle
  post "/:slug/comments" => "comments#create", as: :choogle_comments
  post "/:slug/notifications" => "notifications#create", as: :choogle_notifications
  get "/:slug/proposals/new" => "proposals#new", as: :new_choogle_proposal
  post ":slug/proposals" => "proposals#create", as: :choogle_proposals
  post "/:slug/proposals/:id/upvotes" => "upvotes#create", as: :upvote


end
