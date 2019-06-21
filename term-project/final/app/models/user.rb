class User < ApplicationRecord

  def self.fetch_user(user_public_hash)
    user = @@deepq_client.get_data_entry_by_data_certificate(@@users_directoryID, user_public_hash)
    user_data = JSON.parse(user["dataDescription"])

    user_name                     = user_data["user_name"]
    user_public_hash              = user_data["user_public_hash"]
    password                      = user_data["password"]
    user_transactions_directoryID = user_data["user_transactions_directoryID"]

    User.new(user_name: user_name, user_public_hash: user_public_hash, user_public_hash: user_public_hash,\
      password: password, user_transactions_directoryID: user_transactions_directoryID)
  end

  def calc_current_point
    UserTransaction.calc_current_point(self.user_transactions_directoryID)
  end

end
