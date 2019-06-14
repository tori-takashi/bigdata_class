class Article < ApplicationRecord
  #belongs_to :owner_user_hash, class_name: "User"

  def fetch_title
    @deepq_client = DeepqClient.new
    directoryID = self.directoryID
    dataCertificate = "version_1_part_0"
    result = @deepq_client.get_data_entry_by_data_certificate(directoryID, dataCertificate)
    result["dataDescription"]
  end

  def fetch_content
    @deepq_client = DeepqClient.new
    directoryID = self.directoryID
    dataCertificate = "version_1_part_1"
    result = @deepq_client.get_data_entry_by_data_certificate(directoryID, dataCertificate)
    result["dataDescription"]
  end

end
