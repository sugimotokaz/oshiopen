class NotificationsController < ApplicationController
  def index
    @notifications = current_user.passive_notifications.order(created_at: :desc).page(params[:page]).per(20)
  end

  def destroy
    @notification = current_user.passive_notifications.find(params[:id])
    @notification.destroy!
  end

  def mark_as_read
    notification = current_user.passive_notifications.find(params[:id])
    notification.update(checked: true)
    redirect_to notification.article
  end


end
