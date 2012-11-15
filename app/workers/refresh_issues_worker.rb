class RefreshIssuesWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(issue_id)
    issue = Issue.find(issue_id)
    repo = issue.repo
    github_connection = GithubConnection.new(repo.owner_name, repo.name, issue.git_number)
    issue.update_issue_attributes(github_connection)
  end

end