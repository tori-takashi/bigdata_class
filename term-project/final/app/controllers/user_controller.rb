class UserController < ApplicationController
  require 'securerandom'

  def new
    @user_public_hash = SecureRandom.uuid
  end

  def create

    #users directory ID
      #dataDescription
        user_name                     = params[:user_name]
        password                      = params[:password]
        user_public_hash              = params[:user_public_hash]
        user_transactions_directoryID = deepq_client.create_directory
        created_at                    = Time.new
        #monero account
        #salt
        #public_key

        user_data_description = user_data_description_builder(user_name, password, user_public_hash,\
          user_transactions_directoryID, created_at)

      #dataCertificate
        dataCertificate_user = user_public_hash

      #commit user
        register_user(users_directoryID, user_public_hash, password)
        register_user(user_transactions_directoryID, user_public_hash, password)

        user = user_builder(user_data_description, dataCertificate_user)
        commit_user(users_directoryID, user)

        session[:user_public_hash] = user[:user_public_hash]
        redirect_to article_index_path

  end

  def login
  end

  def auth
    user = deepq_client.get_data_entry_by_data_certificate(users_directoryID, params[:user_public_hash])
    if user && user["dataDescription"]
      user_data = JSON.parse(user["dataDescription"])

      if user_data["password"].present? && user_data["password"] == params[:password]
        session[:user_public_hash]  = user_data["user_public_hash"]
        redirect_to article_index_path
      else
        render user_login_path
      end

    else
      render user_login_path
    end
  end

  def logout
    session[:user_public_hash]  = nil
    redirect_to article_index_path
  end

  private

  def user_data_description_builder(user_name, password, user_public_hash,\
    user_transactions_directoryID, created_at)

    user_data_description =\
    { user_name: user_name,\
      password: password,\
      user_public_hash: user_public_hash,\
      user_transactions_directoryID: user_transactions_directoryID,\
      created_at: created_at }
  end

  def user_builder(dataDescription, dataCertificate)
    user = {dataDescription: dataDescription, dataCertificate: dataCertificate}
  end

  def commit_user(users_directoryID, user)
    directoryID     = users_directoryID
    userID          = user[:dataDescription][:user_public_hash]
    password        = user[:dataDescription][:password]
    offerPrice      = "0"
    dueDate         = "0"
    dataCertificate = user[:dataCertificate]
    dataOwner       = user[:dataDescription][:user_public_hash]
    dataDescription = user[:dataDescription].to_json
    dataAccessPath  = "AnonJournal"

    deepq_client.create_data_entry(directoryID, userID, password, offerPrice, dueDate,\
      dataCertificate, dataOwner, dataDescription, dataAccessPath)
  end

  def register_user(directoryID, userID, password)
    deepq_client.create_user(directoryID, "provider", userID, password)
  end

end
