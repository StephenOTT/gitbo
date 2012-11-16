class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user 


  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end


  # def login_require
  #   unless current_user
  #     redirect_to login_path, :notice => "please login"
  # end

  # def current_user
  #   @current_user ||= User.find_by_id{session[:user_id])
  # end

  # helper_method :current_user
  #   #copies them to Hellpercontroller for user with views

  # def logged_in?
  #   true if current_user
  # end
end
