class Article < ApplicationRecord

  def fetch_title
    set_client unless is_client_blank?
    directoryID = self.directoryID
    dataCertificate = "version_1_part_0"
    result = @deepq_client.get_data_entry_by_data_certificate(directoryID, dataCertificate)
    result["dataDescription"]
  end

  def fetch_content
    set_client unless is_client_blank?
    directoryID = self.directoryID
    dataCertificate = "version_1_part_1"
    result = @deepq_client.get_data_entry_by_data_certificate(directoryID, dataCertificate)
    result["dataDescription"]
  end

  def is_client_blank?
    @deepq_client
  end

  def set_client
    @deepq_client = DeepqClient.new
  end
end
