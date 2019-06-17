class Article < ApplicationRecord
  #belongs_to :owner_user_hash, class_name: "User"

  def fetch_title
    @deepq_client = DeepqClient.new
    directoryID = self.directoryID
    dataCertificate = "version_1_part_0"
    result = @deepq_client.get_data_entry_by_data_certificate(directoryID, dataCertificate)
    result[:dataDescription]
  end

  def fetch_offer_price
    @deepq_client = DeepqClient.new
    directoryID = self.directoryID
    dataCertificate = "version_1_part_0"
    result = @deepq_client.get_data_entry_by_data_certificate(directoryID, dataCertificate)
    result["offerPrice"]
  end

  def fetch_content
    @deepq_client = DeepqClient.new
    directoryID = self.directoryID
    dataCertificate = "version_1_part_1"
    result = @deepq_client.get_data_entry_by_data_certificate(directoryID, dataCertificate)
    result[:dataDescription]
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

=begin

  def enroll_transaction(user)
    @deepq_client = DeepqClient.new
    directoryID = self.directoryID
    offerPrice = self.fetch_offer_price
    dataCertificate = user.user_hash


    @deepq_client.create_data_entry(directoryID, user.user_hash, "testpass", offerPrice,\
      "99999999", dataCertificate, user.user_hash, "user:" + user.user_hash + " purchased.", "AnonJournal")
      #return eas id
  end
=end
end
