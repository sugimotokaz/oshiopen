class CommentsController < ApplicationController
  def create
    @article = Article.find(params[:article_id])
    @comment = current_user.comments.build(create_comment_params)
    if @comment.save
      @article.create_notification_comment!(current_user, @comment.id)
    end
  end

  def edit
    @comment = current_user.comments.find(params[:id])
  end

  def update
    @comment = current_user.comments.find(params[:id])
    @comment.update(update_comment_params)
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
  end

  private

  def create_comment_params
    params.require(:comment).permit(:body).merge(article_id: params[:article_id])
  end
  
  def update_comment_params
    params.require(:comment).permit(:body, :article_id)
  end
end
