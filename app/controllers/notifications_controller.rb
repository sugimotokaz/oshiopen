class NotificationsController < ApplicationController
  def index
    @notifications = current_user.passive_notifications.page(params[:page]).per(20)
  end

  def mark_as_read
    notification = current_user.passive_notifications.find(params[:id])
    notification.update(checked: true)
    redirect_to notification.article
  end


end
