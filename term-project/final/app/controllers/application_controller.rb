class ApplicationController < ActionController::Base
  helper_method :logged_in?, :current_user

  def initialize
    deepq_client
    users_directoryID
    article_summaries_directoryID
  end

  def logged_in?
    session[:user_public_hash] = nil unless user_exsited?
    !!session[:user_public_hash]
  end

  def deepq_client
    @deepq_client ||= DeepqClient.new
  end

  def users_directoryID
    @users_directoryID ||= AnonJournal::Application.config.users_directoryID
  end

  def article_summaries_directoryID
    @article_summaries_directoryID ||= AnonJournal::Application.config.article_summaries_directoryID
  end

  def current_user
    return unless session[:user_private_hash] && session[:user_public_hash]
    if user_exsited?
      @current_user ||= User.fetch_user(session[:user_private_hash])
    else
      session[:user_public_hash] = nil
    end
  end

  def register_current_user(directoryID)
    userID   = current_user.user_public_hash
    password = current_user.password
    deepq_client.create_user(directoryID, "provider", userID, password)
  end

  def user_exsited?
    result = deepq_client.get_data_entry_by_data_certificate(users_directoryID, session[:user_private_hash])
    false if result.nil?
    true  if result.present?
  end

end
