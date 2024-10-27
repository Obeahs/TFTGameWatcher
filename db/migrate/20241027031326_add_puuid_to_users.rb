class AddPuuidToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :puuid, :string
  end
end
