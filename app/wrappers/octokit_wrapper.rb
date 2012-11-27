class OctokitWrapper

  attr_accessor :client

  def initialize(token)
    @client = Octokit::Client.new(:oauth_token => token)
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

  def fetch_comments(issue)
    comments = client.issue_comments(issue.repo.octokit_id, issue.git_number)
    comments.each do |comment|
      issue.comments.build(
        :body => comment.body,
        :git_update_at => comment.updated_at.to_datetime,
        :git_number => comment.id,
        :owner_name => comment.user.login,
        :owner_image => comment.user.avatar_url
      )
    end
    issue
  end

end
