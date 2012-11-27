class Issue < ActiveRecord::Base
  attr_accessible :body, :git_number, :title, :repo, :comment_count,
 
  :git_updated_at, :state, :owner_name, :owner_image, :owner_endorsement, :bounties, :difficulty


  belongs_to :repo

  has_many :comments
  has_many :bounties

  validates :git_number, :uniqueness => { :scope => :repo_id } 

  has_many :user_votes
  
  # validates :git_number, :uniqueness => { :scope => :repo_id } 


  def self.create_from_github(owner, repo, issue)
    github_connection = GithubConnection.new(owner, repo, issue)

    Issue.new(:git_number => github_connection.issue_number,
              :body => github_connection.issue_body,
              :title => github_connection.issue_title,
              :comment_count => github_connection.issue_comments,
              :git_updated_at => github_connection.issue_git_updated_at,
              :state => github_connection.issue_state,
              :owner_name => github_connection.issue_owner_name,
              :owner_image => github_connection.issue_owner_image
              ).tap do |i|
          i.repo = Repo.find_or_create_by_name("#{repo}")
          i.save

      if i.persisted?
        github_connection.comments.each do |comment|
          Comment.create_from_github( i, comment)
        end
      end
    end
    
  end

  def bounty_total
    self.bounties.inject(0) {|total = 0, bounty| total += bounty.price } 

  end

  def votes
    upvote = self.upvote ||= 0
    downvote = self.downvote ||= 0
    upvote - downvote
  end 

  def popularity
    self.popularity_github * self.popularity_gitbo
  end

  def popularity_github
    (self.comment_count*self.repo.popularity)/10
  end

  def popularity_gitbo
    (self.votes+1.0)/(self.time_since_submission + 2)**1.5
  end

   def time_since_submission
    (Time.now.to_i - self.git_updated_at.to_i)/86400.0
   end 

  def add_vote_by(user, direction = :upvote, int = 1)
    self.increment(direction, int)
    self.user_votes.create(:user => user, direction => 1)
  end


  def add_difficulty_by(user, rank)
    uv = UserVote.find_or_create_by_issue_id_and_user_id(self.id, user.id)
    uv.update_attribute(:difficulty_rating, rank)
  end

  def retrieve_difficulty(user)
    UserVote.find_by_issue_id_and_user_id(self.id, user.id)
  end

  def refresh(github_connection)
    self.update_issue_attributes(github_connection) if self.updated?(github_connection)
  end

  def updated?(github_connection)
    return true unless github_connection.issue_git_updated_at == self.git_updated_at
  end

  def self.all_open_issues
    Issue.all.select do |issue|
      issue.open?
    end
  end

  def open?
    self.state == 'open'
  end

  def update_issue_attributes(github_connection)
    self.update_attributes( :body => github_connection.issue_body,
                            :title => github_connection.issue_title,
                            :comment_count => github_connection.issue_comments,
                            :git_updated_at => github_connection.issue_git_updated_at,
                            :state => github_connection.issue_state )
  end

  def endorsement_by(approval)
    self.send(approval.to_sym)
  end

  def endorsement
    self.owner_endorsement = 1
  end

  def disapproval
    self.owner_endorsement = -1
  end


end
