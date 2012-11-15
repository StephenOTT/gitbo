class Issue < ActiveRecord::Base
  attr_accessible :body, :git_number, :title, :repo, :comment_count, 
  :git_updated_at, :state

  belongs_to :repo

  validates :git_number, :uniqueness => { :scope => :repo_id } 

  def self.create_from_github(owner, repo, issue)
    github_connection = GithubConnection.new(owner, repo, issue)

    Issue.new(:git_number => github_connection.issue_number,
              :body => github_connection.issue_body,
              :title => github_connection.issue_title,
              :comment_count => github_connection.issue_comments,
              :git_updated_at => github_connection.issue_git_updated_at,
              :state => github_connection.issue_state
              ).tap do |i|
      i.repo = Repo.find_or_create_by_name("#{repo}")
      i.save
    end
  end


  def popularity
    upvote = self.upvote ||= 0
    downvote = self.downvote ||= 0
    self.comment_count + upvote - downvote
  end

  def add_upvote(int = 1)
    self.increment(:upvote, int)
  end

  def add_downvote(int = 1)
    self.increment(:downvote, int)
  end

  def refresh(github_connection)
    self.update_issue_attributes(github_connection) if self.updated?(github_connection)
  end

  def updated?(github_connection)
    return true unless github_connection.issue_git_updated_at == self.git_updated_at
  end

  def update_issue_attributes(github_connection)
    self.update_attributes( :body => github_connection.issue_body,
                            :title => github_connection.issue_title,
                            :comment_count => github_connection.issue_comments,
                            :git_updated_at => github_connection.issue_git_updated_at,
                            :state => github_connection.issue_state  )
  end

end
