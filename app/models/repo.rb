class Repo < ActiveRecord::Base

  extend FriendlyId
  friendly_id :name, :use => :slugged
  attr_accessible :description, :name, :open_issues, :owner_name, 
                  :watchers, :issues, :git_updated_at
 
  has_many :issues, :dependent => :destroy

  accepts_nested_attributes_for :issues

  validates :name, :uniqueness => true

  def octokit_id
    "#{self.owner_name}/#{self.name}"
  end
  
  def issues_comment_count
    self.issues.inject(0){|sum, issue| 
      sum + issue.comment_count
    }
  end

  def bounty_total
    total = self.issues.inject(0) { |total, issue| total += issue.bounty_total }
  end

  def updated?(octokit_repo)
    open_issues_updated?(octokit_repo) || watchers_updated?(octokit_repo) || git_updated_at_updated?(octokit_repo)
  end

  def update_repo_attributes(octokit_repo)
    self.update_attributes(:open_issues => octokit_repo.open_issues,
                          :watchers => octokit_repo.watchers,
                          :git_updated_at => octokit_repo.updated_at.to_datetime)
  end

  def db_issue_numbers
    self.issues.collect { |issue| issue.git_number }
  end

  def missing_git_issues(octokit_issues)
    octokit_issues.collect do |issue|
      issue.number
    end
  end

  def db_missing_issues(git_issue_numbers)
    git_issue_numbers.select do |git_num|
      git_num unless self.db_issue_numbers.include?(git_num)
    end
  end

  def create_missing_issues(missing_issues, octokit_client)
    missing_issues.each do |issue_num|
        issue = octokit_client.issue("#{self.owner_name}/#{self.name}", issue_num)
        self.issues.build(
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
    self
  end

  def refresh_and_create_issues(octokit_issues, octokit_client) 
    git_issue_numbers = self.missing_git_issues(octokit_issues)
    missing_issues = self.db_missing_issues(git_issue_numbers)
    self.create_missing_issues(missing_issues, octokit_client)
  end

  def self.is_registered?(repo)
    Repo.find_by_owner_name_and_name(repo[:owner_name], repo[:name])
  end 

  def popularity
    ((self.open_issues * 50) + self.watchers + 1 + (self.issues_comment_count * 20))


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

  def exists_on_github?(token)
    # TODO: replcae fetch_repo with a different method
    begin
      octokit_client = OctokitWrapper.new(token)
      octokit_client.fetch_repo(self)
    rescue Octokit::NotFound
      return false
    end
      return true
  end

private

  def open_issues_updated?(octokit_repo)
    return true unless octokit_repo.open_issues == self.open_issues
      
  end

  def watchers_updated?(octokit_repo)
    return true unless octokit_repo.watchers == self.watchers
   
  end

  def git_updated_at_updated?(octokit_repo)
   return true unless octokit_repo.git_updated_at == self.git_updated_at
    
  end

end
