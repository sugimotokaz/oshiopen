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
    @oshi_details = @profile.fetch_oshi_details.page(params[:page]).per(2) # 推しの詳細情報を取得
  end

  def my_articles
    @profile = Profile.includes(user: :articles).find(params[:id])
    @articles = @profile.user.articles.includes(:oshi_name, :user).order(created_at: :desc)
  
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

    @articles = @articles.page(params[:page])
  end

  def favorite_articles
    @profile = Profile.includes(:user).find(params[:id])
    user = @profile.user
  
    if user == current_user
      @articles = user.favorite_articles.includes(:oshi_name, :user).order(created_at: :desc)
    else
      flash[:danger] = "他のユーザーのお気に入り一覧は閲覧できません"
      redirect_to profile_path(@profile)
    end

    @articles = @articles.page(params[:page])
  end

  def follow_users
    @profile = Profile.includes(:user).find(params[:id])
    user = @profile.user

    if user == current_user
      # フォローしているユーザーを取得
      @following_users = user.following_users.includes(:profile).order(created_at: :desc)
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
