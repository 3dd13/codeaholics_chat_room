class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :content
      t.integer :created_by_user_id

      t.timestamps
    end
    add_index :messages, :created_by_user_id
  end
end
