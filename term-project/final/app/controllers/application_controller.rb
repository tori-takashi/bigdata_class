class ApplicationController < ActionController::Base
  helper_method :logged_in?, :current_user

  # server_info_directoryID
  # it hold the information about
  #   <dataEntry>
  #   // access using index(1)
  #     (dataDescription)
  #       article_list_directoryID
  #       users_directoryID
  # these directoryID are going to be received using server info directoryID

  # it contains below in the separated data entries. use it for index(article list).html
  # it should be used index to show.
  # it stored as CSV format.
  #
  # n >= 0
  #
  # <dataEntry(dataCertificate = version_n)> 
  # //referenced by count and index and get a newest version information
  #   (offerPrice)
  #     price
  #   (dataDescription)
  #     title
  #     author(user_directoryID)
  #     created at (epoch time)
  #     updated at (epoch time)
  #     summary
  #     *article_details_directoryID
  #   (dataCertificate)
  #     version_n
  #
  #   (version_n_part_0)<article details directoryID>
  #   //get latest information using index and dataCertificate
  #     (offerPrice)
  #       price
  #     (dataDescription)
  #       title
  #       author
  #       created_at
  #       updated_at
  #       *purchased_user_directoryID
  #     (datacertificate)
  #       version_n_part_0
  #
  #   (version_n_part_n)<article details directoryID>
  #   //latest and last part of the article
  #     (dataDescription)
  #       content
  #     (dataCertificate)
  #       version_n_part_n
  #
  #   <purchased user information directoryID>
  #     (offerPrice)
  #       price
  #     (dataDescription)
  #       "transaction successed"
  #     (dataCertificate)
  #       user_hash
  
  # it contains account information.
  # one person one dataEntry
  #
  # <dataEntry>
  #   user_id (User defined. up to 20 characters)
  #   public_user_hash(SecureRandom.uuid)
  #   private_user_hash(SecureRandom.uuid)
  #   email
  #   monero_account()
  #   *purchase point history directoryID
  #
  #   <purchase point history directoryID>
  #     add points
  #     purchase article
  #     withdraw point
  # 

  @deepq_client

  def logged_in?
    session[:id] = nil unless user_exsited?
    !!session[:id]
  end

  def deepq_client
    @deepq_client ||= DeepqClient.new
  end

  def users_directoryID
    AnonJournal::Application.config.users_directoryID
  end

  def article_list_directoryID
    AnonJournal::Application.config.article_list_directoryID
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
