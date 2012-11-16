class Bounty < ActiveRecord::Base
  attr_accessible :issue_id, :price, :user_id
  belongs_to :issue
  belongs_to :user

  def display_price
    self.price.to_s.prepend("$").insert(-3, ".")
  end

end
