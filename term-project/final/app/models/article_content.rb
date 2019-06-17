class ArticleContent < ApplicationRecord
  def self.fetch_article_contents(article_contents_directoryID)
    count = @@deepq_client.count_data_entry(article_contents_directoryID)
    contents = @@deepq_client.get_data_entry_by_index(article_contents_directoryID, count)

    details_data = JSON.parse(details["dataDescription"])

    contents = details_data["contents"]
    created_at = details_data["created_at"]

    ArticleContent.new(contents: contents, created_at: created_at)
  end
end
