class RefreshIssuesWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(issue_id)
    issue = Issue.find(174)
    repo = issue.repo

    my_client = Octokit::Client.new(:oauth_token => "b423c6264a4286b2ac12961792b02a33994c7dd6")
    if my_client.issue("#{repo.owner_name}/#{repo.name}", issue.git_number, :since => my_client.last_modified)
      github_connection = GithubConnection.new(repo.owner_name, repo.name, issue.git_number)
      issue.update_issue_attributes(github_connection)
    end
  end

endmy