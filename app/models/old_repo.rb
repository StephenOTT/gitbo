class Repo < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :slugged
  attr_accessible :description, :name, :open_issues, :owner_name, 
                  :watchers, :issues, :git_updated_at
 
  has_many :issues, :dependent => :destroy

  accepts_nested_attributes_for :issues

  validates :name, :uniqueness => true


  # should only be called inside a sidekiq worker
  def self.create_from_github(owner, repo)
    # owner, repo = owner.strip, repo.strip
    github_connection = GithubConnection.new(owner, repo)

    newly_created_repo = Repo.create(:name => github_connection.name,
                :open_issues => github_connection.open_issues,
                :owner_name => github_connection.owner_name,
                :watchers => github_connection.watchers,
                :git_updated_at => github_connection.git_updated_at)

    if newly_created_repo.persisted?
      github_connection.issues.each do |issue|
        Issue.create_from_github(owner, repo, issue.number)
      end
    end
    newly_created_repo
  end

  def popularity
    ((self.open_issues * 50) + self.watchers + (self.issues_comment_count * 20))/100


    # what factors into a popularity score

    # watchers
    # number of open issues
    # number of comments for the issues
    # ADD : number of stars

    # EXAMPLES

    # "twitter/bootstrap" =>
    #   watcher =>  40475
    #   open_issues => 269

    # watcher/issues => 150

    # "joyent/node" =>
    #   watcher => 18743
    #   open_issues => 497

    # watcher/issues => 38

    # # "rails/rails" =>
    #     watcher => 16549
    #     open_issues => 362
    #     comments =>
    #     stars => 

    # watcher/issues => 46


    #   "spree/spree" =>
    #     watchers => 3467
    #     open_issues => 53
    #     comments =>  166
    #     stars =>

    # watcher/issues => 66
  end
  
  def issues_comment_count
    self.issues.inject(0){|sum, issue| 
      sum + issue.comment_count
    }
  end

  def bounty_total
    self.issues.inject(0) { |total, issue| total += issue.bounty_total }
  end

  def updated?(github_connection)
    open_issues_updated?(github_connection) || watchers_updated?(github_connection) || git_updated_at_updated?(github_connection)
  end

  def update_repo_attributes(github_connection)
    self.update_attributes(:open_issues => github_connection.open_issues,
                          :watchers => github_connection.watchers,
                          :git_updated_at => github_connection.git_updated_at)
  end

  def db_issue_numbers
    self.issues.collect { |issue| issue.git_number }
  end

  def missing_git_issues(github_connection)
    github_connection.issues.collect do |issue|
      issue.number
    end
  end

  def db_missing_issues(git_issue_numbers)
    git_issue_numbers.select do |git_num|
      git_num unless self.db_issue_numbers.include?(git_num)
    end
  end

  def create_missing_issues(missing_issues)
    missing_issues.each do |issue_num|
        Issue.create_from_github(self.owner_name, self.name, issue_num)
    end
  end

  def refresh_and_create_issues(github_connection) 
    git_issue_numbers = self.missing_git_issues(github_connection)
    missing_issues = self.db_missing_issues(git_issue_numbers)
    self.create_missing_issues(missing_issues)
  end

  def self.is_registered?(repo)
    Repo.find_by_owner_name_and_name(repo[:owner_name], repo[:name])
  end 

private

  def open_issues_updated?(github_connection)
    return true unless github_connection.open_issues == self.open_issues
      
  end

  def watchers_updated?(github_connection)
    return true unless github_connection.watchers == self.watchers
   
  end

  def git_updated_at_updated?(github_connection)
   return true unless github_connection.git_updated_at == self.git_updated_at
    
  end

end
