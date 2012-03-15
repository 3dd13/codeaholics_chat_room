class ChatRoomsController < SignedInController
  before_filter :find_chat_room, :except => [:index, :new, :create]
  
  # GET /chat_rooms
  # GET /chat_rooms.json
  def index
    all_chat_rooms = ChatRoom.order("created_at DESC")
    @private_chat_rooms, @public_chat_rooms = all_chat_rooms.partition{|chat_room| chat_room.private_room?}
  end

  # GET /chat_rooms/1
  # GET /chat_rooms/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @chat_room }
    end
  end

  # GET /chat_rooms/new
  # GET /chat_rooms/new.json
  def new
    @chat_room = ChatRoom.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @chat_room }
    end
  end

  # GET /chat_rooms/1/edit
  def edit
  end

  # POST /chat_rooms
  # POST /chat_rooms.json
  def create
    @chat_room = ChatRoom.new(params[:chat_room])
    @chat_room.hosted_by_user = current_user

    respond_to do |format|
      if @chat_room.save
        format.html { redirect_to chat_rooms_path, notice: 'Chat room was successfully created.' }
        format.json { render json: @chat_room, status: :created, location: @chat_room }
      else
        format.html { render action: "new" }
        format.json { render json: @chat_room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /chat_rooms/1
  # PUT /chat_rooms/1.json
  def update
    respond_to do |format|
      if @chat_room.update_attributes(params[:chat_room])
        format.html { redirect_to @chat_room, notice: 'Chat room was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @chat_room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chat_rooms/1
  # DELETE /chat_rooms/1.json
  def destroy
    @chat_room.destroy

    respond_to do |format|
      format.html { redirect_to chat_rooms_url }
      format.json { head :no_content }
    end
  end
  
  def start
    @chat_room.start_by_user(current_user)
    redirect_to chat_rooms_path 
  end
  
  def join
    join_password = params[:password]
    if can_join?(@chat_room, current_user, join_password)
      @chat_room.add_attendee(current_user)
      render action: "interactive"
    else
      render action: "private_join"
    end
  end
  
  def leave
#     TODO
#     use this leave action to keep track of who is online
#     can use web socket disconnected callback ?
    redirect_to chat_rooms_path 
  end
  
  def close
    @chat_room.close_by_user(current_user)
    redirect_to chat_rooms_path
  end
  
  private
  
  def can_join?(chat_room, user, password)
    (user == chat_room.hosted_by_user) || 
    !chat_room.private_room? ||
    (chat_room.private_room? && chat_room.verify_password?(password))
  end
  
  def find_chat_room
    @chat_room = ChatRoom.find(params[:id])
  end
end
