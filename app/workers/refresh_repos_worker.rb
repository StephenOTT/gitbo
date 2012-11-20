class RefreshReposWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(repo_id)
    repo = Repo.find(repo_id)
    # github_connection = GithubConnection.new(repo.owner_name, repo.name)
    # repo.update_repo_attributes(github_connection) 
    # repo.refresh_and_create_issues(github_connection)
  end

end

# repos = Repo.all

# repos.each do |repo|
#   gh = GithubConnection.new(repo.owner_name, repo.name)
  
#   client.repo(nil, :since => repos_last_modified)  
# #go through each repo. 
# #half request, has this been updated?

# client = Octokit::Client.new(:oauth_token => token)

#   repo.update_repo_attributes(github_connection) 
#   repo.refresh_and_create_issues(github_connection)
# end

# client.repos(nil, :since => repos_last_modified)