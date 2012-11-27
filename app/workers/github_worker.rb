class RepoWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(owner, repo)
     Repo.create_from_github(owner, repo) 
  end

end 



# client.repositories(nil, :since => repos_last_modified)

# all_repos = Repo.all


# client = Octokit::Client.new(:login => "me", :oauth_token => "oauth2token")

# all_repos.each do |repository|
#   client.repository()                        # (Returns an array of repositories)

# client.ratelimit_remaining                    # 4999

# repos_last_modified = client.last_modified
# client.repositories(nil, :since => repos_last_modified)