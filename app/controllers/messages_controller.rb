class MessagesController < ApplicationController
  def create
    @message = current_user.messages.build(create_message_params)
    @message.save
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
  end

  private

  def create_message_params
    params.require(:message).permit(:body).merge(room_id: params[:room_id])
  end
end
