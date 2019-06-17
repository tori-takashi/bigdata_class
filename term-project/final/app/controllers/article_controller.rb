class ArticleController < ApplicationController

  def index
    @articles = deepq_client.list_data_entry(article_summaries_directoryID)
  end

  def show
    @article = Article.find(params[:id])
    if (logged_in?)
      @is_obtained = @article.is_obtained?(current_user)
      @is_able_to_purchase = has_enough_points?(@article) unless @is_obtained
    end
  end

  def new
  end

  def upload
    created_at       = Time.new
    updated_at       = created_at

    article_summaries_directoryID  = deepq_client.create_directory
    article_details_directoryID    = deepq_client.create_directory
    article_contents_directoryID   = deepq_client.create_directory
    author_manipulate_directoryID  = deepq_client.create_directory
    purchased_users_directoryID    = deepq_client.create_directory

    register_current_user(article_summaries_directoryID)
    register_current_user(article_details_directoryID)
    register_current_user(article_contents_directoryID)
    register_current_user(author_manipulate_directoryID)

    #article_summaries_directoryID
      #dataDescription
        author_id                    = current_user.user_name
        author_public_hash           = current_user.user_public_hash
        created_at
        article_details_directoryID
        purchased_users_directoryID
        author_manipulate_directoryID

        article_summary_data_description = article_summary_data_desciption_builder(author_id,\
          author_public_hash, created_at, article_details_directoryID, purchased_users_directoryID,\
          author_manipulate_directoryID)

      #dataCertificate
        dataCertificate_summary      = article_details_directoryID

      #commit article summary
        article_summary = article_summary_builder(article_summary_data_description, dataCertificate_summary)
        commit_article_summary(article_summaries_directoryID, article_summary)

    #article_details_directoryID
      #offerPrice
        offerPrice                   = params[:offerPrice]

      #dataDescription
        title                        = params[:title]
        summary                      = params[:summary]
        updated_at
        article_contents_directoryID

        article_details_data_description = article_details_data_description_builder(title, summary,\
          updated_at, article_contents_directoryID)

      #dataCertificate
        dataCertificate_details      = "version 0"

      #commit article details
        article_details = article_details_builder(offerPrice, article_details_data_description,\
          dataCertificate_details)
        commit_article_details(article_details)

    #article contents directoryID
      #dataDescription
        dataDescription_contents     = params[:contents]
      #dataCertificate
        dataCertificate_contents     = "version 0 part 0"

      #commit article contents
        article_contents = article_contents_builder(dataDescription_contents, dataCertificate_contents)
        commit_article_contents(article_contents)

    redirect_to article_index_path
  end

  private

  # article summaries functions
  def article_summary_data_desciption_builder(author_id, author_public_hash, created_at,\
    article_details_directoryID, purchased_users_directoryID, author_manipulate_directoryID)

    article_summary_data_description =\
    { author_id: author_id,\
      author_public_hash: author_public_hash,\
      created_at: created_at,\
      article_details_directoryID: article_details_directoryID,\
      purchased_users_directoryID: purchased_users_directoryID,\
      author_manipulate_directoryID: author_manipulate_directoryID }
  end

  def article_summary_builder(dataDescription, dataCertificate)
    article_summary = { dataDescription: dataDescription, dataCertificate: dataCertificate }
  end

  def commit_article_summary(article_summaries_directoryID, article_summary)
    directoryID     = article_summaries_directoryID
    userID          = current_user.user_public_hash
    password        = current_user.password
    offerPrice      = "0"
    dueDate         = "0"
    dataCertificate = article_summary["dataCertificate"]
    dataOwner       = current_user.user_public_hash
    dataDescription = article_summary[:dataDescription].to_json
    dataAccessPath  = "AnonJournal"

    deepq_client.create_data_entry(directoryID, userID, password, offerPrice, dueDate,\
      dataCertificate, dataOwner, dataDescription, dataAccessPath)
  end

  # article details functions
  def article_details_data_description_builder(title, summary, updated_at,\
    article_contents_directoryID)

    article_details_data_description = \
    { title: title,\
      summary: summary,\
      updated_at: updated_at,\
      article_contents_directoryID: article_contents_directoryID }
  end

  def article_details_builder(offerPrice, dataDescription, dataCertificate)
    article_details = {offerPrice: offerPrice, dataDescription: dataDescription,\
      dataCertificate: dataCertificate}
  end

  def commit_article_details(article_details_directoryID, article_details)
    directoryID     = article_details_directoryID
    userID          = current_user.user_public_hash
    password        = current_user.password
    offerPrice      = article_details["offerPrice"]
    dueDate         = "0"
    dataCertificate = article_details["dataCertificate"]
    dataOwner       = current_user.user_public_hash
    dataDescription = article_details[:dataDescription].to_json
    dataAccessPath  = "AnonJournal"

    deepq_client.create_data_entry(directoryID, userID, password, offerPrice, dueDate,\
      dataCertificate, dataOwner, dataDescription, dataAccessPath)
  end

  #article contents functions
  def article_contents_builder(dataDescription, dataCertificate)
    article_contents = {dataDescription: dataDescription, dataCertificate: dataCertificate }
  end

  def commit_article_contents(article_contents_directoryID, article_contents)
    directoryID     = article_contents_directoryID
    userID          = current_user.user_public_hash
    password        = current_user.password
    offerPrice      = "0"
    dueDate         = "0"
    dataCertificate = article_contents["dataCertificate"]
    dataOwner       = current_user.user_public_hash
    dataDescription = article_contents[:dataDescription].to_json
    dataAccessPath  = "AnonJournal"

    deepq_client.create_data_entry(directoryID, userID, password, offerPrice, dueDate,\
      dataCertificate, dataOwner, dataDescription, dataAccessPath)
  end

  #author manipulate
  def author_manipulate_data_description_builder(amount)
    author_manipulate = { amount: amount, created_at: Time.new }
  end

  def author_manipulate_builder(author_manipulate_directoryID, author_manipulate)
    directoryID     = article_contents_directoryID
    userID          = current_user.user_public_hash
    password        = current_user.password
    offerPrice      = "0"
    dueDate         = "0"
    dataCertificate = SecureRandom.hex(16)
    dataOwner       = current_user.user_public_hash
    dataDescription = author_manipulate[:dataDescription].to_json
    dataAccessPath  = "AnonJournal"

    deepq_client.create_data_entry(directoryID, userID, password, offerPrice, dueDate,\
      dataCertificate, dataOwner, dataDescription, dataAccessPath)
  end

  #create purchase history
  def create_purchase_user(purchased_users_directoryID)
    register_user(purchased_users_directoryID)

    directoryID     = purchased_users_directoryID
    userID          = current_user.user_public_hash
    password        = current_user.password
    offerPrice      = "0" # article_details.offerPrice
    dueDate         = "0"
    dataCertificate = current_user.user_public_hash
    dataOwner       = current_user.user_public_hash
    dataDescription = { created_at: Time.new }.to_json
    dataAccessPath  = "AnonJournal"

    deepq_client.create_data_entry(directoryID, userID, password, offerPrice, dueDate,\
      dataCertificate, dataOwner, dataDescription, dataAccessPath)
  end

  def has_enough_points?(article)
    current_user.calc_current_point.to_i > article.fetch_offer_price.to_i
  end


end