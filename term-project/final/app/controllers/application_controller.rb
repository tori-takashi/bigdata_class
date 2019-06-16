class ApplicationController < ActionController::Base
  helper_method :logged_in?, :current_user

  @article_list_directoryID = ""
  # it contains below in the separated data entries. use it for index(article list).html
  # it should be used index to show.
  # it stored CSV format.
  #
  # <dataEntry>
  #   id(incremented)
  #   title(up to 100 characters in data description)
  #   price(up to 100000000000 point)
  #   author(user_directoryID in data description)
  #   created at (epoch time in data description)
  #   updated at (epoch time in data desciprion)
  #   summary(up to 800 characters in data description)
  #
  #   <article details directoryID(in data description) >
  #     <dataEntry>
  #       title
  #       price(offerPrice)
  #       author
  #       content
  #       version(dataCertificate)
  #
  #   <purchased user information>
  #     <dataEntry>
  #       user_hash(dataCertificate)
  #       price(offerPrice)
  #       owner_data(article directoryID)
  
  @users_directoryID = ""
  # it contains account information.
  #
  # <dataEntry>
  #   user_id (User defined. up to 20 characters)
  #   user_hash(SecureRandom.uuid)
  #   email
  #   password_digest
  #
  #   <purchase point history directoryID>
  #     add points
  #     purchase article
  #     withdraw point
  # 
  @article_update_history_directory_ID = ""

  def logged_in?
    session[:id] = nil unless user_exsited?
    !!session[:id]
  end

  def deepq_client
    @deepq_client = DeepqClient.new unless @deepq_client
    @deepq_client
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
