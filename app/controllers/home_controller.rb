class HomeController < ApplicationController
  def index
    started_chat_rooms = ChatRoom.started.order("created_at DESC")
    @private_chat_rooms, @public_chat_rooms = started_chat_rooms.partition{|chat_room| chat_room.private_room?}
    redirect_to chat_rooms_path if current_user
  end
end
