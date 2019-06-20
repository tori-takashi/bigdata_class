class CreatePurchasedUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :purchased_users do |t|
      t.string :offerPrice
      t.string :user_public_hash
      t.string :created_at
    end
  end
end
