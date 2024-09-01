class ProfilesController < ApplicationController
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

  private

  def set_user
    @profile = Profile.find(current_user.id)
  end

  def profile_params
    params.require(:profile).permit(:name, :profile_image, :profile_image_cache, :gender, :birth_year, :self_introduction)
  end

end
