class Ability
  include CanCan::Ability
  
  def initialize(user)
    user ||= User.new # guest user
    
    # if user.role? :admin
    #   can :manage, :all
    # else
    #   can :read, :all
    # end

    if user.role?(:authenticated_user)
      # can :create, Comment
      # can :update, Comment do |comment|
      #   comment.try(:user) == user || user.role?(:moderator)
      can :upvote, Issue
      can :downvote, Issue 
    else
      can :read, :all
    end

      # if user.role?(:issue_author)
      #   can :create, Article
      #   can :update, Article do |article|
      #     article.try(:user) == user
      #   end
      # end

      #repo_owner
  end
end