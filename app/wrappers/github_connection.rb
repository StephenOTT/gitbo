class GithubConnection

  attr_accessor :repo, :info

  def initialize(owner, repo)
    @repo = "#{owner}/#{repo}"
    @info = Octokit.repo(@repo)
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
    @issues ||= Octokit.list_issues(self.repo)
  end

end


# class Issue

#   def intialize(owner, repo)
#     gh_connect = GithubConnection.(#)
# end