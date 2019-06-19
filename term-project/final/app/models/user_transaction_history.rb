class UserTransactionHistory < ApplicationRecord
  def self.fetch_user_transaction_history(user_transaction_history_directoryID)
    @user_transaction_histories = []
    histories = @@deepq_client.list_data_entry(user_transaction_history_directoryID)

    histories.each do |history|
      history_data = JSON.parse(history["dataDescription"])

      amount           = history_data["amount"]
      reason           = history_data["reason"]           #purchase_points, purchase_article,
                                                        #retrieve_points_from_article
      details          = history_data["details"]          #article_directoryID
      created_at       = history_data["created_at"]

      @user_transaction_histories.push(\
        UserTransactionHistory.new(amount: amount, reason: reason, details: details, created_at: created_at)\
      )
    end
  end

  def calc_current_point
    current_point = 0
    @user_transaction_histories.each do |user_transaction_history|
      current_point += user_transaction_history[:amount].to_i
    end
    current_point
  end

end
