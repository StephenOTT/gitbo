class RepoWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(repo_id, token)  
    octokit_client = OctokitWrapper.new(token)
    repo = Repo.find_by_id(repo_id)
    repo = octokit_client.fetch_repo(repo)
    repo = octokit_client.fetch_issues(repo)
    repo.save

    repo.issues.each do |issue|
      issue = octokit_client.fetch_comments(issue)
      issue.save
    end
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