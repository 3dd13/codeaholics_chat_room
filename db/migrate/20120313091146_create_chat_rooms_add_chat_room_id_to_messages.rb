class CreateChatRoomsAddChatRoomIdToMessages < ActiveRecord::Migration
  def change
    create_table :chat_rooms do |t|
      t.string  :name
      t.integer :hosted_by_user_id
      t.string  :status
      t.boolean :private_room
      t.string  :password_encrypted

      t.timestamps
    end
    
    add_column :messages, :chat_room_id, :integer
    add_index :messages, :chat_room_id
  end
end
