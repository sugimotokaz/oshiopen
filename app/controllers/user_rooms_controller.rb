class UserRoomsController < ApplicationController
  def create
    room = Room.find(params[:room_id])
    current_user.join_room(room)
    flash[:success] = "チャットルームに参加しました"
    redirect_to room_path(room)
  end

  def destroy
    room = current_user.user_rooms.find(params[:room_id]).room
    current_user.leave_room(room)
    flash[:success] = "チャットルームから退会しました"
    redirect_to rooms_path
  end
end
