class UserVote < ActiveRecord::Base
  attr_accessible :downvote, :issue_id, :upvote, :user_id, :user, :difficulty_rating
  
  belongs_to :user
  belongs_to :issue

  validates_uniqueness_of :issue_id, :scope => :user_id

  def self.average_difficulty(issue)
    all_issues = UserVote.find_all_by_issue_id(issue)
    total = all_issues.inject(0) { |sum, iss| sum + iss.difficulty_rating }
    total = total / all_issues.count.to_f
    total.round(1)
  end 

end

