Rails.application.routes.draw do
  devise_for :users,
  	controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'pages#home'

  resources :choogles, only: [:new, :create], shallow: true do
  	resources :proposals, only: [:new, :create], shallow: true do
      resources :proposal_tags, only: [:new, :create]
    end
  end
  # We create a custom route to post proposals on choogles#show
  post 'proposals', to: 'choogles#create', as: :proposals
  post 'proposals', to: 'proposals#create', as: :choogle_first_proposals
  # we create a custom get route based on the slug
  get "/:slug" => "choogles#show", as: :choogle
  # this routes use the slug for security reasons,
  # because if not anyone could vote for any proposals with the id of it.
  post "/:slug/proposals/:id/upvotes" => "upvotes#create", as: :upvote

  post "/:slug/comments" => "comments#create", as: :choogle_comments

  post "/:slug/notifications" => "notifications#create", as: :choogle_notifications
end

