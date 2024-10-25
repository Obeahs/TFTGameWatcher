class CreateParticipants < ActiveRecord::Migration[7.2]
  def change
    create_table :participants do |t|
      t.references :match, null: false, foreign_key: true
      t.string :participant_id
      t.integer :placement

      t.timestamps
    end
  end
end
