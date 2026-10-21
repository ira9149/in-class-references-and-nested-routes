class CreateStages < ActiveRecord::Migration[7.1]
  def change
    create_table :stages do |t|
      t.string :name, null: false
      t.integer :capacity, null: false
      t.references :festival, null: false, foreign_key: true

      t.timestamps
    end
  end
end
