class ArticleSummary < ApplicationRecord

  def self.fetch_article_summary(article_details_directoryID)
    summary = @@deepq_client.get_data_entry_by_data_certificate(@@article_summaries_directoryID,\
       article_details_directoryID)
    summary_data = JSON.parse(summary["dataDescription"])

    author_name                   = summary_data["author_name"]
    author_public_hash            = summary_data["author_public_hash"]
    created_at                    = summary_data["created_at"]
    article_details_directoryID   = summary_data["article_details_directoryID"]
    purchased_users_directoryID   = summary_data["purchased_users_directoryID"]

    ArticleSummary.new(author_name: author_name, author_public_hash: author_public_hash,\
      created_at: created_at, article_details_directoryID: article_details_directoryID,\
      purchased_users_directoryID: purchased_users_directoryID)
  end

  def fetch_title
    details = fetch_article_details(self.article_details_directoryID)
    details.title 
  end

  def fetch_offerPrice
    details = fetch_article_details(self.article_details_directoryID)
    details.offerPrice
  end

  def fetch_summary
    details = fetch_article_details(self.article_details_directoryID)
    details.summary
  end

  def is_obtained?(user)
    return true if self.owner_user_hash == user.user_hash
    @deepq_client = DeepqClient.new
    directoryID = self.directoryID
    dataCertificate = user.user_hash
    result = @deepq_client.get_data_entry_by_data_certificate(directoryID, dataCertificate)

    return false if result.nil? || result["message"] != "Data entry is retrieved by data certificate."
    return true  if result["message"] == "Data entry is retrieved by data certificate."
  end

  def fetch_article_details(article_details_directoryID)
    details = ArticleDetail.fetch_article_details(article_details_directoryID)
  end

end
