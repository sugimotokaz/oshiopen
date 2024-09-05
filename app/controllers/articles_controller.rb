class ArticlesController < ApplicationController
  skip_before_action :require_login, only: %i[index show]

  def index
    @articles = Article.includes(:oshi_name, user: :profile).order(created_at: :desc)
  end

  def new
    @article = Article.new
  end

  def create
    oshi_name_name = params[:article][:oshi_name_name]

    if oshi_name_name.present?
      oshi_name = OshiName.find_or_create_by(name: oshi_name_name.strip)
    end

    @article = current_user.articles.build(article_params)
    @article.oshi_name = oshi_name if oshi_name

    if @article.save
      flash[:success] = "記事を作成しました"
      redirect_to articles_path
    else
      flash.now[:danger] = "掲示板を作成できませんでした"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @article = Article.includes(:oshi_name, user: :profile).find(params[:id])
    @comment = Comment.new
    @comments = @article.comments.includes(user: :profile).order(created_at: :asc)
  end

  def edit
    @article = current_user.articles.find(params[:id])
  end

  def update
    oshi_name_name = params[:article][:oshi_name_name]

    if oshi_name_name.present?
      oshi_name = OshiName.find_or_create_by(name: oshi_name_name.strip)
    end

    @article = current_user.articles.find(params[:id])
    @article.oshi_name = oshi_name if oshi_name

    if @article.update(article_params)
      flash[:success] = "記事を更新しました"
      redirect_to articles_path
    else
      flash.now[:danger] = "記事を更新できませんでした"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article = current_user.articles.find(params[:id])
    @article.destroy!
    flash[:success] = "投稿を削除しました"
    redirect_to articles_path, status: :see_other
  end

  private

  def article_params
    params.require(:article).permit(:title, :notice, :category, :visible_gender, :visible_oshi)
  end
end
