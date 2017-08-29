Rails.application.routes.draw do
  devise_for :users,
  	controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'pages#home'
  # needed for Action Cable WS
  mount ActionCable.server, at: '/cable'

  resources :choogles, only: [:create]


  get "/:slug" => "choogles#show", as: :choogle
  post "/:slug/comments" => "comments#create", as: :choogle_comments
  post "/:slug/notifications" => "notifications#create", as: :choogle_notifications

  # we create a custom get route based on the slug

  # this routes use the slug for security reasons,
  # because if not anyone could vote for any proposals with the id of it.
  get "/:slug/proposals/new" => "proposals#new", as: :new_choogle_proposal
  post ":slug/proposals" => "proposals#create", as: :choogle_proposals
  post "/:slug/proposals/:id/upvotes" => "upvotes#create", as: :upvote


end
