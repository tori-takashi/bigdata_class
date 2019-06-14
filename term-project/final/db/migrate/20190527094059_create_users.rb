class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :user_id
      t.string :user_hash
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
