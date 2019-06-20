class ArticleController < ApplicationController

  def index
    @article_summaries = []
    summary_array = deepq_client.list_data_entry(@article_summaries_directoryID)
    summary_array.each do |summary|
      article_summary_arguments = JSON.parse(summary["dataDescription"])
      article_summary = ArticleSummary.new(article_summary_arguments)
      @article_summaries.push(article_summary)
    end
  end

  def view
    @article_summary = ArticleSummary.fetch_article_summary(params[:article_details_directoryID])
    @details = ArticleDetail.fetch_article_details(params[:article_details_directoryID])
    @is_obtained_article = is_obtained_article?(params[:article_details_directoryID])
    @is_author = is_author?(params[:article_details_directoryID])
  end

  def new
  end

  def upload
    created_at = Time.new
    updated_at = created_at

    article_summaries_directoryID  = @article_summaries_directoryID
    article_details_directoryID    = deepq_client.create_directory
    article_contents_directoryID   = deepq_client.create_directory
    purchased_users_directoryID    = deepq_client.create_directory

    register_current_user(article_summaries_directoryID)
    register_current_user(article_details_directoryID)
    register_current_user(article_contents_directoryID)

    #article_summaries_directoryID
      #dataDescription
        author_name                    = current_user.user_name
        author_public_hash           = current_user.user_public_hash
        created_at
        article_details_directoryID
        purchased_users_directoryID

        article_summary_data_description = article_summary_data_desciption_builder(author_name,\
          author_public_hash, created_at, article_details_directoryID, purchased_users_directoryID)

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
        commit_article_details(article_details_directoryID, article_details)

    #article contents directoryID
      #dataDescription
        dataDescription_contents     = params[:contents]
        created_at                   = Time.new

        article_contents_data_description = article_contents_data_description_builder(dataDescription_contents,\
          created_at)
      #dataCertificate
        dataCertificate_contents     = "version 0 part 0"

      #commit article contents
        article_contents = article_contents_builder(article_contents_data_description,\
          dataCertificate_contents)
        commit_article_contents(article_contents_directoryID, article_contents)

    redirect_to article_index_path
  end

  private

  # article summaries functions
  def article_summary_data_desciption_builder(author_name, author_public_hash, created_at,\
    article_details_directoryID, purchased_users_directoryID )

    article_summary_data_description =\
    { author_name: author_name,\
      author_public_hash: author_public_hash,\
      created_at: created_at,\
      article_details_directoryID: article_details_directoryID,\
      purchased_users_directoryID: purchased_users_directoryID }
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
    dataCertificate = article_summary[:dataCertificate]
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
    offerPrice      = article_details[:offerPrice]
    dueDate         = "0"
    dataCertificate = article_details[:dataCertificate]
    dataOwner       = current_user.user_public_hash
    dataDescription = article_details[:dataDescription].to_json
    dataAccessPath  = "AnonJournal"

    deepq_client.create_data_entry(directoryID, userID, password, offerPrice, dueDate,\
      dataCertificate, dataOwner, dataDescription, dataAccessPath)
  end

  #article contents functions
  def article_contents_data_description_builder(contents, created_at)
    article_contents_data_description = { contents: contents, created_at: created_at}
  end

  def article_contents_builder(dataDescription, dataCertificate)
    article_contents = {dataDescription: dataDescription, dataCertificate: dataCertificate }
  end

  def commit_article_contents(article_contents_directoryID, article_contents)
    directoryID     = article_contents_directoryID
    userID          = current_user.user_public_hash
    password        = current_user.password
    offerPrice      = "0"
    dueDate         = "0"
    dataCertificate = article_contents[:dataCertificate]
    dataOwner       = current_user.user_public_hash
    dataDescription = article_contents[:dataDescription].to_json
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

  def is_obtained_article?(article_details_directoryID)
    return false unless logged_in?
    article_summary = ArticleSummary.fetch_article_summary(article_details_directoryID)

    result = deepq_client.get_data_entry_by_data_certificate(article_summary.purchased_users_directoryID,\
      current_user.user_public_hash)
    
     !result.nil? && !result["dataDescription"].nil? &&\
       (JSON.parse(result["dataDescription"]))["user_public_hash"] == current_user.user_public_hash
  end

  def is_author?(article_details_directoryID)
    return false unless logged_in?
    article_summary = ArticleSummary.fetch_article_summary(article_details_directoryID)
    article_summary.author_public_hash == current_user.user_public_hash
  end

end
