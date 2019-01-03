class CreateMonsters < ActiveRecord::Migration[5.2]
  def change
    create_table :monsters do |t|
      t.string :name
      t.string :pairs
      t.integer :count
      t.string :memo

      t.timestamps
    end
  end
end
