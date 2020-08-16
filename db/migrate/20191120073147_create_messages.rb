class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.references :user,    null: false, foreign_key: true
      t.references :request, null: false, foreign_key: true
      t.string :text
      t.string :picture

      t.timestamps
    end
  end
end
