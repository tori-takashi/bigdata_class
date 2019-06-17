class User < ApplicationRecord

  def self.fetch_user(user_private_hash)
    user = @@deepq_client.get_data_entry_by_data_certificate(@@users_directoryID, user_private_hash)
    user_data = JSON.parse(user["dataDescription"])

    user_name                     = user_data["user_name"]
    user_public_hash              = user_data["user_public_hash"]
    user_private_hash             = user_data["user_private_hash"]
    password                      = user_data["password"]
    user_transactions_directoryID = user_data["user_transactions_directoryID"]

    User.new(user_name: user_name, user_public_hash: user_public_hash, user_private_hash: user_private_hash,\
      password: password, user_transactions_directoryID: user_transactions_directoryID)
  end

  def calc_current_point
    deepq_client = DeepqClient.new
    histories = deepq_client.list_data_entry(self.purchase_history_directoryID)
    current_point = 0

    if histories.present?
      histories.each_with_index do |history, i|
        transaction_point = history[1][:dataDescription].split(" ")[1].to_i
        current_point += transaction_point
      end
    end
    
    current_point
  end

end
