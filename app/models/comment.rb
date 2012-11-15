class Comment < ActiveRecord::Base
  attr_accessible :body, :git_number, :git_update_at, :issue_id, :owner_image, :owner_name
  belongs_to :issue

  def self.create_from_github( issue, comment)

    issue.comments.build( :body => comment.body,
                          :git_update_at => comment.updated_at.to_datetime,
                          :git_number => comment.id,
                          :owner_name => comment.user.login,
                          :owner_image => comment.user.avatar_url)
    
    issue.save 
  end

end
