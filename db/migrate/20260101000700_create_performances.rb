class CreatePerformances < ActiveRecord::Migration[7.1]
  def change
    create_table :performances do |t|
      t.datetime :starts_at, null: false
      t.references :stage, null: false, foreign_key: true
      t.references :artist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
