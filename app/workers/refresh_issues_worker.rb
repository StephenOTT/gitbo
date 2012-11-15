class RefreshIssuesWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(issue, github_connection)
    issue.update_issue_attributes(github_connection)
  end

end