class FavoritesController < ApplicationController
  def create
    @article = Article.find(params[:article_id])
    current_user.favorite(@article)
  end

  def destroy
    @article = current_user.favorites.find(params[:id]).article
    current_user.unfavorite(@article)
  end
end
