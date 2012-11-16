require 'sidekiq/web'

Gitbo::Application.routes.draw do

  get '/:owner/:repo/issues/:git_no/bounty/new' => "bounties#new", :as => :new_bounty

  resources :bounties

  resources :comments

  resources :users

  #authentication through github
  match '/auth/:provider/callback' => 'sessions#create'
  get '/signout' => "sessions#destroy", :as => :signout

  get "/:owner/:repo/issues" => "issues#repo_issues", :as => :repo_issues

  #voting
  put '/issues/:id/vote/:direction' => 'issues#vote', :as => :vote_issue
  #owner endorsment
  put '/issues/:id/endorsement/:direction' => 'issues#endorsement', :as => :owner_endorsement

  resources :repos do
    #this needs to be cleaned up. Most of these have been depreciated.
    resources :issues, :only => [:index, :delete, :update]
  end

  get "/issues" => "issues#index"

  get "/:owner/:repo/issues/:git_number" => 'issues#show', :as => :owner_repo_gitnumber
  get "/:owner/*repo" => 'repos#show', :as => :owner_repo, :format => false
  get "/:owner" => 'repos#show_owner', :as => :owner_repos


  ### sidekiq monitoring
  mount Sidekiq::Web, at: "/sidekiq"

  root :to => 'static#index'

  end
