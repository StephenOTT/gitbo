class Bounty < ActiveRecord::Base
  attr_accessible :issue_id, :price, :user_id
end
