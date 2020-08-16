class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.references :user,     null: false, foreign_key: true
      t.string     :payjp_id, null: false
      t.string     :card_id,  null: false
      t.timestamps
    end
  end
end
