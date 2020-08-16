class CreateRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :requests do |t|
      t.string  :title,        null: false
      t.text    :content,      null: false
      t.integer :reward,       null: false
      t.bigint  :client_id,    null: false
      t.bigint  :contractor_id
      t.integer :condition,    null: false, default: 0, limit: 1
      t.timestamps
    end
    add_foreign_key :requests, :users, column: :client_id
    add_foreign_key :requests, :users, column: :contractor_id
  end
end
