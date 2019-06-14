class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :directoryID
      t.references :owner_user_hash

      t.timestamps
    end
  end
end
