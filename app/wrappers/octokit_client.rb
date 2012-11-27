class OctokitClient

  attr_accessor :client

  def initialize(token)
    @client = Octokit::Client.new(:oauth_token => token)
  end

  def fetch_issues(repo)
    issues = client.list_issues(repo.octokit_id)
    issues.each do |issue|
      repo.issues.build(
        :git_number => issue.number,
        :body => issue.body,
        :title => issue.title,
        :comment_count => issue.comments,
        :git_updated_at => issue.updated_at.to_datetime,
        :state => issue.state,
        :owner_name => issue.user.login,
        :owner_image => issue.user.avatar_url
       )
    end
    repo
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
