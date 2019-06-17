class CreateArticleSummaries < ActiveRecord::Migration[5.2]
  def change
    create_table :article_summaries do |t|
      t.string :author_name
      t.string :author_public_hash
      t.string :created_at
      t.string :author_manipulate_directoryID
      t.string :article_details_directoryID
      t.string :purchased_users_directoryID
    end
  end
end
