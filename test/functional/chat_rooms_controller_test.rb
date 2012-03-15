require 'test_helper'

class ChatRoomsControllerTest < ActionController::TestCase
  setup do
    @chat_room = chat_rooms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:chat_rooms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create chat_room" do
    assert_difference('ChatRoom.count') do
      post :create, chat_room: @chat_room.attributes
    end

    assert_redirected_to chat_room_path(assigns(:chat_room))
  end

  test "should show chat_room" do
    get :show, id: @chat_room
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @chat_room
    assert_response :success
  end

  test "should update chat_room" do
    put :update, id: @chat_room, chat_room: @chat_room.attributes
    assert_redirected_to chat_room_path(assigns(:chat_room))
  end

  test "should destroy chat_room" do
    assert_difference('ChatRoom.count', -1) do
      delete :destroy, id: @chat_room
    end

    assert_redirected_to chat_rooms_path
  end
end
