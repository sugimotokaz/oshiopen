class RelationshipsController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user)
  end

  def destroy
    relationship = current_user.active_relationships.find(params[:id])
    @user = relationship.followed
    current_user.unfollow(@user)
  end
end
