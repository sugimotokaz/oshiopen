class ArticlesController < ApplicationController
  skip_before_action :require_login, only: %i[index]

  def index
    @articles = Article.includes(:oshi_name, user: :profile).all
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
  end

  private

  def article_params
    params.require(:article).permit(:title, :notice, :category, :visible_gender, :visible_oshi)
  end
end
