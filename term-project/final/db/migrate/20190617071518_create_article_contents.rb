class CreateArticleContents < ActiveRecord::Migration[5.2]
  def change
    create_table :article_contents do |t|
      t.string :contents
      t.string :created_at
      t.string :version_part
    end
  end
end
