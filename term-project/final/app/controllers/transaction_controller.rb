class TransactionController < ApplicationController

  def purchase_article
    article_details_directoryID = params[:article_details_directoryID]

    article_summary = ArticleSummary.fetch_article_summary(article_details_directoryID)
    article_details = ArticleDetail.fetch_article_details(article_details_directoryID)

    purchased_users_directoryID = article_summary.purchased_users_directoryID

    unless has_enough_point?(article_details.offerPrice)
      redirect_to view_article_path(article_details_directoryID)
      return
    end

    #purchased_users_directoryID
      #offerPrice
        offerPrice        = article_details.offerPrice

      #dataDescription
        user_public_hash = current_user.user_public_hash
        created_at        = Time.new

        user_purchased_data_description = user_purchased_data_description_builder(user_public_hash,\
          created_at)

      #dataCertificate
        dataCertificate   = current_user.user_public_hash

      #commit user_purchased
        user_purchased = user_purchased_builder(offerPrice, user_purchased_data_description, dataCertificate)
        commit_user_purchased(purchased_users_directoryID, user_purchased)

    #user(purchasing an article)_transactions_directoryID
      #offerPrice
        offerPrice

      #dataDescription
        amount = (offerPrice.to_i)*-1
        reason = "purchase_article"
        details = article_details.title
        created_at

        user_transaction_data_description = user_transaction_data_description_builder(\
          amount, reason, details, created_at)

      #dataCertificate
        dataCertificate = SecureRandom.hex(64)

      #commit user transaction
        user_transaction = user_transaction_builder(offerPrice, user_transaction_data_description,\
          dataCertificate)
        commit_user_transaction(current_user.user_transactions_directoryID, user_transaction)

    #user(uploaded author) transactions_directoryID
      article_summary = ArticleSummary.fetch_article_summary(article_details_directoryID)

      author_public_hash = article_summary.author_public_hash
      author_transactions_directoryID = User.fetch_user(author_public_hash).user_transactions_directoryID

      register_current_user(author_transactions_directoryID)

      #offerPrice
        offerPrice

      #dataDescription
        amount = offerPrice.to_i
        reason = "purchased_your_article"
        details = article_details.title
        created_at

        author_transaction_data_description = user_transaction_data_description_builder(\
          amount, reason, details, created_at)

      #dataCertificate
        dataCertificate = SecureRandom.hex(64)

      #commit author transaction
        author_transaction = user_transaction_builder(offerPrice, author_transaction_data_description,\
          dataCertificate)
        commit_user_transaction(author_transactions_directoryID, author_transaction)

        redirect_to view_article_path(article_details_directoryID)
        
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

  def user_purchased_data_description_builder(user_public_hash, created_at)
    user_purchased_data_description = { user_public_hash: user_public_hash, created_at: created_at }
  end

  def user_purchased_builder(offerPrice, dataDescription, dataCertificate)
    user_purchased = {offerPrice: offerPrice, dataDescription: dataDescription, dataCertificate: dataCertificate}
  end

  def commit_user_purchased(purchased_users_directoryID, user_purchased)
    register_current_user(purchased_users_directoryID)

    directoryID     = purchased_users_directoryID
    userID          = current_user.user_public_hash
    password        = current_user.password
    offerPrice      = user_purchased[:offerPrice]
    dueDate         = "0"
    dataCertificate = user_purchased[:dataCertificate]
    dataOwner       = current_user.user_public_hash
    dataDescription = user_purchased[:dataDescription].to_json
    dataAccessPath  = "AnonJournal"

    deepq_client.create_data_entry(directoryID, userID, password, offerPrice, dueDate,\
      dataCertificate, dataOwner, dataDescription, dataAccessPath)
  end

  def purchase_history
    directoryID = current_user.user_transactions_directoryID
    @transactions = UserTransaction.fetch_user_transactions(directoryID)
    @current_point = current_user.calc_current_point
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