class CreateHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :histories do |t|
      t.string :user_name
      t.string :monster_name

      t.timestamps
    end
  end
end
