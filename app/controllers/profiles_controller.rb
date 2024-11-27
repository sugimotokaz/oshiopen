class ProfilesController < ApplicationController
  skip_before_action :require_login, only: %i[show my_articles]
  before_action :set_user, only: %i[new create edit update]

  def new
    @profile = Profile.new
  end

  def create
    @profile = Profile.new(profile_params)
    if @profile.save
      flash[:success] = "プロフィールを更新しました"
      redirect_to profile_path
    else
      flash.now[:danger] = "プロフィールを更新できませんでした"
      render :edit, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @profile.update(profile_params)
      @profile.user.update(name: params[:profile][:name]) # nameカラムの更新
      flash[:success] = "プロフィールを更新しました"
      redirect_to profile_path
    else
      flash.now[:danger] = "プロフィールを更新できませんでした"
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @profile = Profile.find(params[:id])
    @user = @profile.user  # プロフィール所有者のユーザーを取得
    @oshi_details = @profile.fetch_oshi_details.page(params[:page]).per(5) # 推しの詳細情報を取得
  end

  def my_articles
    @profile = Profile.includes(user: :articles).find(params[:id])
    @q = @profile.user.articles.ransack(params[:q])
    @articles = @q.result(distinct: true).includes(:oshi_name, :user).order(created_at: :desc)
  
    if logged_in?
      if current_user == @profile.user
        # 作成者はすべての記事を表示（statusによるフィルタリングなし）
        @articles = @articles
      else
        # 作者以外には公開中の記事のみ表示
        @articles = @articles.where(status: :published)
  
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
      end
    else
      # ログインしていない場合は「選択なし」の記事のみ表示
      @articles = @articles.where(status: :published, visible_gender: 0, visible_oshi: false)
    end
  
    @articles = @articles.page(params[:page])
  end

  def favorite_articles
    @profile = Profile.includes(:user).find(params[:id])
    user = @profile.user
  
    if user == current_user
      @q = user.favorite_articles.ransack(params[:q])
      @articles = @q.result(distinct: true).includes(:oshi_name, :user).order(created_at: :desc)

      # 公開中の記事のみを取得
      @articles = @articles.where(status: :published)
  
      # 公開条件を適用
      if current_user.profile.gender.present?
        @articles = @articles.where(visible_gender: [0, Profile.genders[current_user.profile.gender]])
      else
        @articles = @articles.where(visible_gender: 0)
      end
  
      if current_user.profile.oshi_details.any?
        oshi_name_ids = current_user.profile.oshi_details.pluck(:oshi_name_id)
        @articles = @articles.where('visible_oshi = ? OR (visible_oshi = ? AND oshi_name_id IN (?))', false, true, oshi_name_ids)
      else
        @articles = @articles.where(visible_oshi: false)
      end
    else
      flash[:danger] = "他のユーザーのお気に入り一覧は閲覧できません"
      redirect_to profile_path(@profile)
      return
    end
  
    @articles = @articles.page(params[:page])
  end

  def follow_users
    @profile = Profile.includes(:user).find(params[:id])
    user = @profile.user

    if user == current_user
      @q = user.following_users.ransack(params[:q])
      # フォローしているユーザーを取得
      @following_users = @q.result(distinct: true).includes(:profile).order(created_at: :desc)
    else
      flash[:danger] = "他のユーザーのお気に入りユーザー一覧は閲覧できません"
      redirect_to profile_path(@profile)
    end

    @following_users = @following_users.page(params[:page])
  end

  private

  def set_user
    @profile = Profile.find(current_user.id)
  end

  def profile_params
    params.require(:profile).permit(:profile_image, :profile_image_cache, :gender, :birth_year, :self_introduction)
  end

end
