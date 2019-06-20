class ArticleContent < ApplicationRecord
  def self.fetch_article_contents(article_contents_directoryID)
    count = @@deepq_client.count_data_entry(article_contents_directoryID) -1
    contents = @@deepq_client.get_data_entry_by_index(article_contents_directoryID, count)

    version = contents["dataCertificate"]

    contents_data = JSON.parse(contents["dataDescription"])
    contents = contents_data["contents"]
    created_at = contents_data["created_at"]

    ArticleContent.new(contents: contents, created_at: created_at)
  end
end
