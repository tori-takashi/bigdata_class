class User < ApplicationRecord
  has_secure_password
  #has_many :articles

  def calc_current_point
    deepq_client = DeepqClient.new
    histories = deepq_client.list_data_entry(self.purchase_history_directoryID)
    current_point = 0


#    if histories.present?

#      histories.each_with_index do |history, i|
 #       transaction_data = history[i]
  #      current_point += transaction_data
   #   end

#    end
    
    current_point
  end

end
