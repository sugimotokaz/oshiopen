class FavoritesController < ApplicationController
  def create
    article = Article.find(params[:article_id])
    current_user.favorite(article)
    flash[:success] = "お気に入り登録しました"
    redirect_to articles_path
  end

  def destroy
    article = current_user.favorites.find(params[:id]).article
    current_user.unfavorite(article)
    flash[:success] = "お気に入り解除しました"
    redirect_to articles_path, status: :see_other
  end
end
