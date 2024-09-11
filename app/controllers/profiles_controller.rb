class ProfilesController < ApplicationController
  skip_before_action :require_login, only: %i[show articles]
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
      flash[:success] = "プロフィールを更新しました"
      redirect_to profile_path
    else
      flash.now[:danger] = "プロフィールを更新できませんでした"
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @profile = Profile.find(params[:id])
    @oshi_details = @profile.fetch_oshi_details # 推しの詳細情報を取得
  end

  def articles
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
  end

  private

  def set_user
    @profile = Profile.find(current_user.id)
  end

  def profile_params
    params.require(:profile).permit(:name, :profile_image, :profile_image_cache, :gender, :birth_year, :self_introduction)
  end

end
