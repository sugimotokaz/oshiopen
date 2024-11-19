class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy]
  before_action :check_owner, only: [:edit, :update, :destroy]

  def index
    @rooms = Room.all.page(params[:page]).per(15)
  end

  def new
    @room = Room.new
  end

  def create
    @room = current_user.owned_rooms.new(room_params)
    if @room.save
      # チャットルーム作成者を自動的に参加させる
      @room.users << current_user
      flash[:success] = "チャットルームが作成されました"
      redirect_to rooms_path
    else
      flash.now[:danger] = "チャットルームを作成できませんでした"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @message = Message.new
    @messages = @room.messages.includes(:user).order(created_at: :asc)
  end

  def edit; end

  def update
    if @room.update(room_params)
      flash[:success] = "チャットルームを更新しました"
      redirect_to rooms_path
    else
      flash.now[:danger] = "チャットルームを更新できませんでした"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @room.destroy!
    flash[:success] = "チャットルームを削除しました"
    redirect_to rooms_path, status: :see_other
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def room_params
    params.require(:room).permit(:name, :description)
  end

  def check_owner
    redirect_to rooms_path, alert: "権限がありません" unless @room.owner == current_user
  end

end
