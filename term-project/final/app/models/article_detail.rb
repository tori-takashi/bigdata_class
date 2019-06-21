class ArticleDetail < ApplicationRecord
  def self.fetch_article_details(article_details_directoryID)
    count = @@deepq_client.count_data_entry(article_details_directoryID) -1
    latest_details = @@deepq_client.get_data_entry_by_index(article_details_directoryID, count)

    latest_details_data = JSON.parse(latest_details["dataDescription"])

    title                        = latest_details_data["title"]
    status                       = latest_details_data["status"]
    offerPrice                   = latest_details["offerPrice"]
    summary                      = latest_details_data["summary"]
    updated_at                   = latest_details_data["updated_at"]
    article_contents_directoryID = latest_details_data["article_contents_directoryID"]
    version                      = latest_details["dataCertificate"]
    article_details_directoryID  = article_details_directoryID

    ArticleDetail.new(title: title, status: status, offerPrice: offerPrice, summary: summary, updated_at: updated_at,\
      version: version, article_contents_directoryID: article_contents_directoryID)
  end

  def fetch_article_contents
    contents = ArticleContent.fetch_article_contents(self.article_contents_directoryID)
  end

end
