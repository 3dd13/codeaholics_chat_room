class MessagesController < SignedInController
  before_filter :find_chat_room

  def post_message
    message_content = params[:message_content]
    unless message_content.blank?
      @message = @chat_room.messages.build(content: message_content)
      @message.created_by_user = current_user
      @message.save
    end
  end  
  
  private
  
  def find_chat_room
    # TODO check if the user can post
    @chat_room = ChatRoom.find(params[:chat_room_id], :include => {:messages => :created_by_user})
  end
end
