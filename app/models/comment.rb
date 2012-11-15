class Comment < ActiveRecord::Base
  attr_accessible :body, :git_number, :git_update_at, :issue_id, :owner_image, :owner_name
  belongs_to :issue
end
