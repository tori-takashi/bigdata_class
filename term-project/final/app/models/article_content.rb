class ArticleContent < ApplicationRecord
  def self.fetch_article_contents(article_contents_directoryID)
    count = @@deepq_client.count_data_entry(article_contents_directoryID) -1
    latest_last_contents = @@deepq_client.get_data_entry_by_index(article_contents_directoryID, count)

    contents = ""
    created_at = JSON.parse(latest_last_contents["dataDescription"])["created_at"]

    latest_version_data = latest_last_contents["dataCertificate"].split(" ")

    latest_version = latest_version_data[1].to_i
    last_part      = latest_version_data[3].to_i

    (last_part + 1).times do |i|
      dataCertificate = "version #{latest_version} part #{i}"
      latest_contents = @@deepq_client.get_data_entry_by_data_certificate(article_contents_directoryID,\
        dataCertificate)

      contents += JSON.parse(latest_contents["dataDescription"])["contents"] \
        unless JSON.parse(latest_contents["dataDescription"])["contents"].nil?
    end


    ArticleContent.new(contents: contents, created_at: created_at)
  end
end
