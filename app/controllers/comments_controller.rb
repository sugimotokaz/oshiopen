class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(create_comment_params)
    @comment.save
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
