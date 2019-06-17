class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :user_public_hash
      t.string :user_private_hash
      t.string :password
      t.string :user_transactions_directoryID
    end
  end
end
