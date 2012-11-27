class OctokitClient

  attr_accessor :client

  def initialize(token)
    @client = Octokit::Client.new(:oauth_token => token)
  end

  def fetch_issue(issue)
    self.
  end

  #expects repo with owner_name and name
  #returns fully populated repo
  def fetch_repo(repo)
    info = client.repo(repo.octokit_id)
    repo.open_issues = info.open_issues
    repo.owner_name = info.owner.login
    repo.watchers = info.watchers
    repo.git_updated_at = info.updated_at.to_datetime
    repo
  end
end
