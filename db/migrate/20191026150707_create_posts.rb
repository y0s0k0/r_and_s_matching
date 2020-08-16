class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.references :request,            null: false, foreign_key: true
      t.string     :image
      t.integer    :delete_instruction, null: false, default: 0
      t.timestamps
    end
  end
end
