class GithubWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(owner, repo)
     Repo.create_from_github(owner, repo) 
  end

end 

class RefreshWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(issue, github_connection)
    issue.update_issue_attributes(github_connection)
  end

end