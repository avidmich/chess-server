class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :event
      t.string :site
      t.datetime :date_started
      t.integer :round
      t.references :white
      t.references :black
      t.string :result
      t.text :text

      t.timestamps
    end
  end
end
