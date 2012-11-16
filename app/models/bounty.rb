class Bounty < ActiveRecord::Base
  attr_accessible :issue_id, :price, :user_id
  belongs_to :issue
  belongs_to :user
end
