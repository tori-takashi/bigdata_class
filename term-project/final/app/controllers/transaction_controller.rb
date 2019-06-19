class TransactionController < ApplicationController

  def purchase_article
    article = Article.find(params[:article_id])

    unless has_enough_points?
      redirect_to article_path(params[:article_id])
      return
    end

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

  def has_enough_points?(article)
    current_point = current_user.calc_current_point
    current_point - article.fetch_offer_price > 0
  end

  def add_point
  end

  def purchase_point 
    user_transactions_directoryID = current_user.user_transactions_directoryID

    #user_transactions_directoryID
      #offerPrice
        offerPrice = params[:point]

      #dataDescription
        amount          = params[:point]
        reason          = "purchase_point"
        details         = "purchase #{params[:point]} point"
        created_at      = Time.new

        user_transaction_data_description = user_transaction_data_description_builder(\
          amount, reason, details, created_at)

      #dataCertificate
        dataCertificate = SecureRandom.hex(64)

      #commit user transaction
        user_transaction = user_transaction_builder(offerPrice, user_transaction_data_description,\
          dataCertificate)
        commit_user_transaction(current_user.user_transactions_directoryID, user_transaction)

      redirect_to article_index_path
  end

  def purchase_history
    directoryID = current_user.user_transactions_directoryID
    @histories = deepq_client.list_data_entry(directoryID)
  end

  def user_transaction_data_description_builder(amount, reason, details, created_at)
    user_transaction_data_description = { amount: amount, reason: reason, details: details,\
      created_at: created_at }
  end

  def user_transaction_builder(offerPrice, dataDescription, dataCertificate)
    user_transaction = {offerPrice: offerPrice, dataDescription: dataDescription,\
      dataCertificate: dataCertificate}
  end

  def commit_user_transaction(user_transactions_directoryID, user_transaction)
    directoryID     = user_transactions_directoryID
    userID          = current_user.user_public_hash
    password        = current_user.password
    offerPrice      = user_transaction[:dataDescription][:amount]
    dueDate         = "0"
    dataCertificate = user_transaction[:dataCertificate]
    dataOwner       = current_user.user_public_hash
    dataDescription = user_transaction[:dataDescription].to_json
    dataAccessPath  = "AnonJournal"

    deepq_client.create_data_entry(directoryID, userID, password, offerPrice, dueDate,\
      dataCertificate, dataOwner, dataDescription, dataAccessPath)
  end

end