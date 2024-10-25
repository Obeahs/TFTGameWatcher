class CreateMatchChampions < ActiveRecord::Migration[7.2]
  def change
    create_table :match_champions do |t|
      t.references :match, null: false, foreign_key: true
      t.integer :champion_id

      t.timestamps
    end
  end
end
