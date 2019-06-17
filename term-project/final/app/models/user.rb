class User < ApplicationRecord
  has_secure_password
  #has_many :articles

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
