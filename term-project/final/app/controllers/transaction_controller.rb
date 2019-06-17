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
    points = params[:points]
    dataCertificate = "#{current_user.user_hash},#{SecureRandom.hex(16)}" 
    dataDescription = "Add #{points}"

    deepq_client.create_data_entry(current_user.purchase_history_directoryID,\
      current_user.user_hash + "_provider", "testpass", points, "99999999", dataCertificate,\
      current_user.user_hash + "_provider", dataDescription, "AnonJournal")

    redirect_to article_index_path
  end

  def purchase_history
    directoryID = current_user.purchase_history_directoryID
    @histories = deepq_client.list_data_entry(directoryID)
  end

  def article_history
  end
end