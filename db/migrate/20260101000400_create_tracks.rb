class CreateTracks < ActiveRecord::Migration[7.1]
  def change
    create_table :tracks do |t|
      t.string :title, null: false
      t.integer :length_sec, null: false
      t.references :artist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
