class ArticleController < ApplicationController
  def initialize
    @deepq_client = DeepqClient.new
  end

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
  end

  def upload
    directoryID = write_to_data_directory(params[:title], params[:content])
    create_article_record(directoryID)
    redirect_to article_index_path
  end

  def create_article_record(directoryID)
    create_article_params = {directoryID: directoryID}
    article = Article.new(create_article_params)
    article.save
  end

  def write_to_data_directory(title, content)

    create_directory_result = @deepq_client.create_directory

    directoryID = create_directory_result["directoryID"]
    userType = "provider"
    userID = "testuser001"
    password = "testuser001"

    @deepq_client.create_user(directoryID, userType, userID, password)
    # create user in the data directory

    offerPrice_title = "1000"
    offerPrice_content = "0"
    dueDate = "9999"
    dataCertificate_title = "version_1_part_0"
    dataCertificate_content = "version_1_part_1"
    dataOwner = userID
    dataDescription_title = title
    dataDescription_content = content
    dataAccessPath = "AnonJournal"


    @deepq_client.create_data_entry(directoryID, userID, password, offerPrice_title, dueDate, \
      dataCertificate_title, dataOwner, dataDescription_title, dataAccessPath)
      # create data directory for title
    @deepq_client.create_data_entry(directoryID, userID, password, offerPrice_content, dueDate, \
      dataCertificate_content, dataOwner, dataDescription_content, dataAccessPath)
      # create data directory for content
    
    directoryID
  end

end
