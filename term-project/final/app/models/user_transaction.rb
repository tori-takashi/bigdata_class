class UserTransaction < ApplicationRecord
  def self.fetch_user_transactions(user_transactions_directoryID)
    @user_transactions = []
    transactions = @@deepq_client.list_data_entry(user_transactions_directoryID)

    transactions.each do |transaction|
      transaction = JSON.parse(transaction["dataDescription"])

      amount           = transaction["amount"]
      reason           = transaction["reason"]           #purchase_point, purchase_article,
                                                        #retrieve_point_from_article
      details          = transaction["details"]          #article_directoryID
      created_at       = transaction["created_at"]

      @user_transactions.push(\
        UserTransaction.new(amount: amount, reason: reason, details: details, created_at: created_at)\
      )
    end
    @user_transactions
  end

  def self.calc_current_point(user_transactions_directoryID)
    @user_transactions = self.fetch_user_transactions(user_transactions_directoryID)
    current_point = 0
    @user_transactions.each do |user_transaction|
      current_point += user_transaction[:amount].to_i
    end
    current_point
  end

end
