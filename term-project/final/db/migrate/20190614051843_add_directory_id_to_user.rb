class AddDirectoryIdToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :purchase_history_directoryID, :string
  end
end
