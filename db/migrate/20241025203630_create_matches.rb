class CreateMatches < ActiveRecord::Migration[7.2]
  def change
    create_table :matches do |t|
      t.string :match_id
      t.references :user, null: false, foreign_key: true
      t.string :game_type

      t.timestamps
    end
  end
end
