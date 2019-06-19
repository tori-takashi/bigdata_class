class CreateUserTransactionHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :user_transaction_histories do |t|
      t.string :amount
      t.string :reason
      t.string :details
      t.string :created_at
    end
  end
end
