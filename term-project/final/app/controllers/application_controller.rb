class ApplicationController < ActionController::Base
  helper_method :logged_in?, :current_user

  def logged_in?
    session[:id] = nil unless user_exsited?
    !!session[:id]
  end

  def current_user
    return unless session[:id]
    if user_exsited?
      @current_user ||= User.find(session[:id]) 
    else
      session[:id] = nil
    end
  end

  def user_exsited?
    User.where(id: session[:id]).present?
  end

end
