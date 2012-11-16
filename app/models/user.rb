class User < ActiveRecord::Base
  attr_accessible :provider, :uid, :name, :image

  has_many :user_votes
  has_many :bounties

  def self.create_with_omniauth(auth)
  create! do |user|
    user.provider = auth["provider"]
    user.uid = auth["uid"]
    user.name = auth["info"]["name"]
    user.nickname = auth["info"]["nickname"]
    user.email = auth["info"]["email"]
    user.image = auth["info"]["image"]
    end
  end

  def session_token
    session[:token]
  end
  
end
