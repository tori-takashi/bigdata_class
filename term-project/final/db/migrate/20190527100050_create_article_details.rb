class CreateArticleDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :article_details do |t|
      t.string :title
      t.string :summary
      t.string :offerPrice
      t.string :updated_at
      t.string :article_contents_directoryID
      t.string :article_details_directoryID
      t.string :version
    end
  end
end
