class CreateUnits < ActiveRecord::Migration[7.2]
  def change
    create_table :units do |t|
      t.references :participant, null: false, foreign_key: true
      t.string :character_id
      t.integer :tier
      t.text :items

      t.timestamps
    end
  end
end
