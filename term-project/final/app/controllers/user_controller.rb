class UserController < ApplicationController
  require 'securerandom'
  def new
    @user = User.new
  end

  def create
    if User.new(register_params).valid?
      parameters = register_params

      user_hash = SecureRandom.uuid

      deepq_client = DeepqClient.new
      purchase_history_directoryID = deepq_client.create_directory
      deepq_client.create_user(purchase_history_directoryID, "provider", user_hash + "_provider",\
        "testpass")

      parameters[:user_hash] = user_hash
      parameters[:purchase_history_directoryID] = purchase_history_directoryID

      User.new(parameters).save!

      session[:id] = User.find_by(user_hash: user_hash).id
      redirect_to article_index_path
    else
      render 'new'
    end
  end

  def login
    @user = User.new
  end

  def auth
    user = User.find_by(email: login_params[:email])
    if user.authenticate(login_params[:password])
      session[:id] = user.id
      redirect_to article_index_path
    else
      render user_login_path
    end
  end

  def logout
    session[:id] = nil
    redirect_to article_index_path
  end

  def buy_article
    article = Article.find(params[:article_id])
    deepq_client = DeepqClient.new
    article_dataCertificate = current_user.user_hash
    article_data_directoryID = article.directoryID

    deepq_client.create_user(article_data_directoryID, "provider", current_user.user_hash, "testpass")
    deepq_client.create_data_entry(article_data_directoryID, current_user.user_hash, "testpass", "0",\
      "99999999", article_dataCertificate, current_user.user_hash, article_dataCertificate, "AnonJournal")

    offerPrice = article.fetch_offer_price
    purchase_history_dataCertificate = article.directoryID
    purchase_history_dataDescription = "#{article.directoryID} #{-offerPrice.to_i}"
    purchase_history_directoryID = current_user.purchase_history_directoryID

    deepq_client.create_data_entry(purchase_history_directoryID, current_user.user_hash + "_provider",\
      "testpass", offerPrice, "99999999", purchase_history_dataCertificate,\
      current_user.user_hash, purchase_history_dataDescription, "AnonJournal")

    redirect_to article_path(params[:article_id])

  end

  def add_point
    points = params[:points]
    dataCertificate = "#{current_user.user_hash},#{SecureRandom.hex(16)}" 
    dataDescription = "Add" + " " + points
    deepq_client = DeepqClient.new

    deepq_client.create_data_entry(current_user.purchase_history_directoryID,\
      current_user.user_hash + "_provider", "testpass", points, "99999999", dataCertificate,\
      current_user.user_hash + "_provider", dataDescription, "AnonJournal")

    redirect_to article_index_path
  end

  private def register_params
    params.require(:user).permit(:user_id, :email, :password, :password_confirmation)
  end

  private def login_params
    puts params
    params.require(:user).permit(:email, :password)
  end

end
