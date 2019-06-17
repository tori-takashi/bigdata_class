class ApplicationController < ActionController::Base
  helper_method :logged_in?, :current_user

  # server_info_directoryID
  # it hold the information about
  #   <dataEntry>
  #   // access using index(1)
  #     (dataDescription)
  #       article_summaries_directoryID
  #       users_directoryID
  # these directoryID are going to be received using server info directoryID

  # it contains below in the separated data entries. use it for index(article list).html
  # it should be used index to show.
  # it stored as CSV format.
  #
  # n >= 0
  #

  # <article_summary_directoryID(dataCertificate = version n)> 
  # //referenced by count and index and get a newest version information
  #   (offerPrice)
  #     price
  #   (dataDescription)
  #     title
  #     summary
  #     author(user_directoryID)
  #     created at (epoch time)
  #     updated at (epoch time)
  #     *article_details_directoryID
  #     *purchased_user_directoryID
  #   (dataCertificate)
  #     version n
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
  
  # it contains account information.
  # one person one dataEntry
  #
  # <dataEntry>
  #   user_name (User defined. up to 20 characters)
  #   public_user_hash(SecureRandom.uuid)  => kind of user identifier
  #   private_user_hash(SecureRandom.uuid) => kind of password
  #   email
  #   monero_account()
  #   *purchase point history directoryID
  #
  #   <purchase point history directoryID>
  #     add points
  #     purchase article
  #     withdraw point

  @deepq_client

  def logged_in?
    session[:user_public_hash] = nil unless user_exsited?
    !!session[:user_public_hash]
  end

  def deepq_client
    @deepq_client ||= DeepqClient.new
  end

  def users_directoryID
    AnonJournal::Application.config.users_directoryID
  end

  def article_summaries_directoryID
    AnonJournal::Application.config.article_summaries_directoryID
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
