class Api::V1::ChatRoomsController < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false

  def index
    render json: ChatRoom.all
  end

  def create
    chat_room = current_user.chat_rooms.new(chat_room_params)
    if chat_room.save
      render json: chat_room, status: :created
    else
      render json: { errors: chat_room.errors.full_messages }, status: :unprocessable_entity
    end
  end
  

  def show
    chat_room = ChatRoom.find(params[:id])
    render json: chat_room
  end
  def destroy
    chat_room = ChatRoom.find(params[:id])
    chat_room.destroy
    head :no_content
  end
  
  private
  def chat_room_params
    params.require(:chat_room).permit(:name)
  end
end
  