class OshiDetailsController < ApplicationController
  before_action :set_oshi_detail, only: %i[edit update destroy]

  def new
    @oshi_detail = OshiDetail.new
  end

  def create
    # 入力された推しの名前を受け取る
    oshi_name_name = params[:oshi_detail][:oshi_name_name]
  
    # 既存の推し名がある場合、それを見つけるか、新たに作成する
    if oshi_name_name.present?
      oshi_name = OshiName.find_or_create_by(name: oshi_name_name.strip)
    end
  
    # 新しいOshiDetailを作成し、そのOshiNameを関連付ける
    @oshi_detail = current_user.profile.oshi_details.new(oshi_detail_params)
    @oshi_detail.oshi_name = oshi_name if oshi_name
  
    if @oshi_detail.save
      flash[:success] = "推し情報を更新しました"
      redirect_to profile_path(current_user.profile)
    else
      flash.now[:danger] = "推し情報を更新できませんでした"
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    # 入力された推しの名前を受け取る
    oshi_name_name = params[:oshi_detail][:oshi_name_name]
    
    # 既存の推し名がある場合、それを見つけるか、新たに作成する
    if oshi_name_name.present?
      oshi_name = OshiName.find_or_create_by(name: oshi_name_name.strip)
    end
  
    # OshiName を関連付ける
    @oshi_detail.oshi_name = oshi_name if oshi_name
    
    # OshiDetail を更新
    if @oshi_detail.update(oshi_detail_params)
      flash[:success] = "推し情報を更新しました"
      redirect_to profile_path(current_user.profile)
    else
      flash.now[:danger] = "推し情報を更新できませんでした"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @oshi_detail.destroy!
    flash[:success] = "推し情報を削除しました"
    redirect_to profile_path(current_user.profile), status: :see_other
  end

  private

  def set_oshi_detail
    @oshi_detail = OshiDetail.find(params[:id])
  end

  def oshi_detail_params
    params.require(:oshi_detail).permit(:oshi_image, :oshi_image_cache, :reason_for_favorite, :trigger_for_favorite, :activity_history)
  end
end
