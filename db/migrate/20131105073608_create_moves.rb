class CreateMoves < ActiveRecord::Migration
  def change
    create_table :moves do |t|
      t.integer :move_number
      t.string :move_from
      t.string :move_to

      t.timestamps
    end
  end
end
