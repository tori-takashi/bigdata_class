module TransactionHelper
  def is_history_article_directoryID?(target)
    true if target =~ Regexp.new("^0x.*")
  end

  def get_data_description_from_history(history, index)
    history[1]["dataDescription"].split(" ")[index]
  end

  def get_article_title(directoryID)
    Article.find_by(directoryID: directoryID).fetch_title
  end

  def get_article_id(directoryID)
    Article.find_by(directoryID: directoryID).id
  end
end
