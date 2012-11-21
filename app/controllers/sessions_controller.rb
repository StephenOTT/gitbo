class SessionsController < ApplicationController
  
  def new
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    session[:token] = auth.credentials.token

    client = Octokit::Client.new(:oauth_token => auth.credentials.token)

    Rails.cache.fetch(user.nickname.to_sym, expires_in: 24.hours) do
      { :repos => client.repositories(user.nickname).collect {|repo| repo.name },
        :following => client.following(user.nickname).collect {|user| user.login },
        :starred => client.starred(user.nickname).collect {|repo| "#{repo.owner.login}/#{repo.name}" }  }
    end



    redirect_to root_url, :notice => "Signed in!"

  end

  def destroy
    session[:user_id] = nil
    session[:token] = nil
    redirect_to root_url, :notice => "Signed out!"
  end

end
