class CreateFestivals < ActiveRecord::Migration[7.1]
  def change
    create_table :festivals do |t|
      t.string :name, null: false
      t.date :starts_on, null: false
      t.string :city, null: false

      t.timestamps
    end
  end
end
