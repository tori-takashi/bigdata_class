class ArticleController < ApplicationController

  def index
    @articles = articles_builder
  end

  def view
    @article_summary = ArticleSummary.fetch_article_summary(params[:article_details_directoryID])
    @details = ArticleDetail.fetch_article_details(params[:article_details_directoryID])
    @contents = @details.fetch_article_contents.contents
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
        author_public_hash             = current_user.user_public_hash
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
        status                       = params[:status]
        summary                      = params[:summary]
        updated_at
        article_contents_directoryID

        article_details_data_description = article_details_data_description_builder(title, status, summary,\
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

  def update_article

    @contents = params[:contents]
    @article_details_directoryID = params[:article_details_directoryID]
    @is_author = is_author?(@article_details_directoryID)

    @article_details = ArticleDetail.fetch_article_details(@article_details_directoryID)
    @article_contents_directoryID = @article_details.article_contents_directoryID

    @current_version_number = @article_details.version.split(" ")[1].to_i
  end

  def commit_changes
    update_version_number = params[:current_version_number].to_i + 1

    article_details_directoryID = params[:article_details_directoryID]
    article_contents_directoryID = params[:article_contents_directoryID]

    #article_details_directoryID
      #offerPrice
        offerPrice                   = params[:offerPrice]

      #dataDescription
        title                        = params[:title]
        status                       = params[:status]
        summary                      = params[:summary]
        updated_at                   = Time.new
        article_contents_directoryID

        article_details_data_description = article_details_data_description_builder(title, status, summary,\
          updated_at, article_contents_directoryID)

      #dataCertificate
        dataCertificate_details      = "version #{update_version_number}"

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
        dataCertificate_contents     = "version #{update_version_number} part 0"

      #commit article contents
        article_contents = article_contents_builder(article_contents_data_description,\
          dataCertificate_contents)
        commit_article_contents(article_contents_directoryID, article_contents)
        
    if status == "deleted"
      redirect_to article_index_path
    else
      redirect_to view_article_path(article_details_directoryID)
    end
  end

  def uploaded_articles
    @uploaded_articles = []
    articles = articles_builder

    @uploaded_articles = articles.select{ |article| 
      article[:article_summary][:author_public_hash] == current_user.user_public_hash &&\
        article[:article_details].status != "deleted"
    }
  end

  private

  def articles_builder
    articles = []
    summary_array = deepq_client.list_data_entry(@article_summaries_directoryID)
    summary_array.each do |summary|
      article = []
      article_summary_arguments = JSON.parse(summary["dataDescription"])

      article_summary = ArticleSummary.new(article_summary_arguments)
      article_details = ArticleDetail.fetch_article_details(article_summary.article_details_directoryID)

      articles.push({article_summary: article_summary, article_details: article_details})
    end
    articles
  end

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
  def article_details_data_description_builder(title, status, summary, updated_at,\
    article_contents_directoryID)

    article_details_data_description = \
    { title: title,\
      status: status,\
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
    word_count = article_contents[:dataDescription][:contents].length
    split_count = (word_count/one_content_max_word) + 1
    
    directoryID     = article_contents_directoryID
    userID          = current_user.user_public_hash
    password        = current_user.password
    offerPrice      = "0"
    dueDate         = "0"
    dataCertificate = article_contents[:dataCertificate]
    dataOwner       = current_user.user_public_hash
    #dataDescription
    dataAccessPath  = "AnonJournal"

    dataDescription_array = article_contents[:dataDescription][:contents].scan(/.{1,#{one_content_max_word}}/m)

    version = dataCertificate.split(" ")[1]

    split_count.times do |i|
      splitted_dataDescription = article_contents_data_description_builder(dataDescription_array[i],\
        article_contents[:dataDescription][:created_at]).to_json
      splitted_dataCertificate = "version #{version} part #{i}"

      deepq_client.create_data_entry(directoryID, userID, password, offerPrice, dueDate,\
        splitted_dataCertificate, dataOwner, splitted_dataDescription, dataAccessPath)
    end

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
