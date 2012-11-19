class GithubConnection

  attr_accessor :repo, :info, :issue_no, :client, :issues, :name, :comments

  def initialize(owner, repo, issue = nil, token = nil)

    @client = Octokit::Client.new(:oauth_token => token)
    @repo = "#{owner}/#{repo}"
    @info = @client.repo(@repo)
    @issues = @client.list_issues(@repo)
    repo = "#{owner}/#{repo}"
    issue_no = issue
    if issue
      @issue_no = issue
      @comments = @client.issue_comments( repo, issue_no)
    end
  end

  def self.repo_params(*args)
    args.each do |arg|
      define_method arg.to_sym do
        self.info.send(arg)
      end
    end
  end
    repo_params :name, :open_issues, :watchers

  def git_updated_at
    self.info.updated_at.to_datetime
  end

  def owner_name
    self.info.owner.login
  end

  def self.issue_params(*args)
    args.each do |arg|
      define_method ("issue_#{arg}").to_sym do
        self.client.issue(self.repo, self.issue_no).send(arg)
      end
    end
  end
    issue_params :comments, :title, :body, :number, :state

  def issue_git_updated_at
    self.client.issue(self.repo, self.issue_no).updated_at.to_datetime
  end

  def issue_owner_name
    self.client.issue(self.repo, self.issue_no).user.login
  end

  def issue_owner_image
    self.client.issue(self.repo, self.issue_no).user.avatar_url
  end
  
end

