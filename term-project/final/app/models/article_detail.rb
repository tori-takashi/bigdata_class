class ArticleDetail < ApplicationRecord
  def self.fetch_article_details(article_details_directoryID)
    count = @@deepq_client.count_data_entry(article_details_directoryID)
    details = @@deepq_client.get_data_entry_by_index(article_details_directoryID, count)

    details_data = JSON.parse(details["dataDescription"])

    title                        = details_data["title"]
    offerPrice                   = JSON.parse(details["offerPrice"])
    summary                      = details_data["summary"]
    updated_at                   = details_data["updated_at"]
    article_contents_directoryID = details_data["article_contents_directoryID"]
    version                      = details_data["version"]

    ArticleDetail.new(title: title, offerPrice: offerPrice, summary: summary, updated_at: updated_at,\
      article_content_directoryID: article_content_directoryID)

  end

end
