class PurchasedUser < ApplicationRecord
  def self.fetch_purchased_users(purchased_users_directoryID)
    @purchased_users = []
    users_data = @@deepq_client.list_data_entry(purchased_users_directoryID)

    users_data.each do |user_data|
      user = JSON.parse(user_data["dataDescription"])

      offerPrice        = user_data["offerPrice"].to_i
      user_public_hash = user["user_public_hash"]
      created_at        = user["created_at"]

      @purchased_users.push(\
        PurchasedUser.new(offerPrice: offerPrice, user_public_hash: user_public_hash,\
            created_at: created_at))
    end
    @user_transactions
  end

  def self.fetch_purchased_user(purchased_users_directoryID, user_public_hash)
    user_data = @@deepq_client.get_data_entry_by_data_certificate(purchased_users_directoryID, user_public_hash)
    user = JSON.parse(user_data["dataDescription"])

    offerPrice        = user["offerPrice"].to_i
    user_public_hash = user["user_public_hash"]
    created_at        = user["created_at"]

    PurchasedUser.new(offerPrice: offerPrice, user_public_hash: user_public_hash, created_at: created_at)
  end

end
