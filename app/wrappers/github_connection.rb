class GithubConnection

  def initialize(owner, repo)
    @owner = owner
    @repo = repo
    @info = Octokit.repo("#{@owner}/#{@repo}")
  end

  def url
    self.info.html_url
  end

  def name
    self.info.name
  end

  def owner
    self.info.owner
  end

  def issues
    Octokit.list_issues("#{@owner}/#{@repo}")
  end

end