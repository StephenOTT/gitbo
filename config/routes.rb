require 'sidekiq/web'

Gitbo::Application.routes.draw do

  resources :comments

  resources :users

  #authentication through github
  match '/auth/:provider/callback' => 'sessions#create'
  get '/signout' => "sessions#destroy", :as => :signout

  get "/:owner/:repo/issues" => "issues#repo_issues", :as => :repo_issues

  put '/issues/:id/upvote' => 'issues#upvote', :as => :upvote_issue
  put '/issues/:id/downvote' => 'issues#downvote', :as => :downvote_issue

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
