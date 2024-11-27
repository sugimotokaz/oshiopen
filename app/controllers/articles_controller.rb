class ArticlesController < ApplicationController
  skip_before_action :require_login, only: %i[index show]

  def index

    # Ransack検索オブジェクトを作成
    @q = Article.ransack(params[:q])
  
    # タグIDがパラメータにある場合、そのタグに関連する記事のみを取得
    if params[:q] && params[:q][:tags_id_eq].present?
      tag = Tag.find(params[:q][:tags_id_eq])
      @articles = tag.articles.includes(:oshi_name, :tags, user: :profile).order(created_at: :desc)
    else
      @articles = @q.result(distinct: true).includes(:oshi_name, :tags, user: :profile).order(created_at: :desc)
    end

    # 公開中の記事のみを対象にフィルタリング
    @articles = @articles.where(status: :published)
  
    if logged_in?
      # 作成した記事には常にアクセスできるようにする
      user_created_articles = @articles.where(user_id: current_user.id)
  
      # 性別によるフィルタリング
      if current_user.profile.gender.present?
        @articles = @articles.where(visible_gender: [0, Profile.genders[current_user.profile.gender]])
      else
        @articles = @articles.where(visible_gender: 0)
      end
  
      # 同じ推し名を持つユーザーに対してのみ表示するフィルタリング
      if current_user.profile.oshi_details.any?
        oshi_name_ids = current_user.profile.oshi_details.pluck(:oshi_name_id)
        @articles = @articles.where('visible_oshi = ? OR (visible_oshi = ? AND oshi_name_id IN (?))', false, true, oshi_name_ids)
      else
        @articles = @articles.where(visible_oshi: false)
      end
  
      # 作成者自身には常に記事を表示
      @articles = @articles.or(user_created_articles)
  
    else
      # ログインしていない場合は「選択なし」の記事のみ表示
      @articles = @articles.where(visible_gender: 0, visible_oshi: false)
    end

    # ページネーションを追加
    @articles = @articles.page(params[:page])
  end

  def new
    @article = Article.new
  end

  def create
    oshi_name_name = params[:article][:oshi_name_name]
    tag_name = params[:article][:tag_name]

    if oshi_name_name.present?
      oshi_name = OshiName.find_or_create_by(name: oshi_name_name.strip)
    end

    @article = current_user.articles.build(article_params)
    @article.oshi_name = oshi_name if oshi_name

    if tag_name.present?
      tags = tag_name.split("、").map(&:strip).uniq
      tags.each do |name|
        tag = Tag.find_or_create_by(name: name)
        @article.tags << tag unless @article.tags.include?(tag)
      end
    end

    if params[:unpublished].present?
      @article.status = :unpublished
    else
      @article.status = :published
    end

    if @article.save
      if @article.unpublished?
        flash[:success] = "非公開で保存しました"
        redirect_to my_articles_profile_path(current_user.profile)
      else
        flash[:success] = "記事を作成しました"
        redirect_to articles_path
      end
    else
      flash.now[:danger] = "記事を作成できませんでした"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # タグIDがパラメータにある場合、そのタグに関連する記事のみを取得
    if params[:q] && params[:q][:tags_id_eq].present?
      tag = Tag.find(params[:q][:tags_id_eq])
      @articles = tag.articles.includes(:oshi_name, :tags, user: :profile).order(created_at: :desc)
    else
      @article = Article.includes(:oshi_name, user: :profile).find(params[:id])
    end

    if logged_in?
      # 作成者自身の場合は表示
      if current_user.id == @article.user_id
        # 作成者自身には表示するので、そのまま何もしない
      else
        # 公開中（`status: :published`）の記事のみ表示
        unless @article.published?
          flash[:danger] = 'この記事は表示できません'
          redirect_to articles_path
          return
        end

        # 性別によるフィルタリング
        if current_user.profile.gender.present?
          # ログインユーザーの性別に合わせてフィルタリング
          user_gender = Profile.genders.key(Profile.genders[current_user.profile.gender])
          
          unless ["not_selected", user_gender].include?(@article.visible_gender)
            flash[:danger] = 'この記事は表示できません'
            redirect_to articles_path
            return
          end
        else
          # 「選択なし」の場合のみ表示
          unless @article.visible_gender == "not_selected"
            flash[:danger] = 'この記事は表示できません'
            redirect_to articles_path
            return
          end
        end
    
        # 同じ推し名を持つユーザーに対してのみ表示するフィルタリング
        if @article.visible_oshi
          oshi_name_ids = current_user.profile.oshi_details.pluck(:oshi_name_id)
          unless oshi_name_ids.include?(@article.oshi_name_id)
            flash[:danger] = 'この記事は表示できません'
            redirect_to articles_path
            return
          end
        end
      end
    else
      # ログインしていない場合、「選択なし」の記事のみ表示
      unless @article.published? && @article.visible_gender == "not_selected" && !@article.visible_oshi
        flash[:danger] = 'この記事は表示できません'
        redirect_to articles_path
        return
      end
    end

    @comment = Comment.new
    @comments = @article.comments.includes(user: :profile).order(created_at: :desc)
  end

  def edit
    @article = current_user.articles.find(params[:id])
  end

  def update
    oshi_name_name = params[:article][:oshi_name_name]
    tag_name = params[:article][:tag_name]

    if oshi_name_name.present?
      oshi_name = OshiName.find_or_create_by(name: oshi_name_name.strip)
    end

    @article = current_user.articles.find(params[:id])
    @article.oshi_name = oshi_name if oshi_name

    if tag_name.present?
      @article.tags.clear
      tags = tag_name.split("、").map(&:strip).uniq
      tags.each do |name|
        tag = Tag.find_or_create_by(name: name)
        @article.tags << tag unless @article.tags.include?(tag)
      end
    end

    if params[:unpublished].present?
      @article.status = :unpublished
      success_message = "非公開にしました。"
      redirect_path = my_articles_profile_path(current_user.profile)
    else
      @article.status = :published
      success_message = "投稿を更新しました。"
      redirect_path = articles_path
    end

    if @article.update(article_params)
      redirect_to redirect_path, success: success_message
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
    params.require(:article).permit(:title, :notice, :category, :visible_gender, :visible_oshi, :status, :content)
  end
end
