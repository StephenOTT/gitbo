class UserVoteController < ApplicationController

  def add_upvote
    uv= UserVote.new
    uv.user_id = current_user.id
    uv.issue_id = Issue.find(:id)
    uv.upvote = 1
  end

  def add_downvote
    uv= UserVote.new
    uv.user_id = current_user.id
    uv.issue_id = Issue.find(:id)
    uv.downvote = 1
  end
  
end
