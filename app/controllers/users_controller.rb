class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    @sign_up_form = SignUpForm.new
  end

  def create
    @sign_up_form = SignUpForm.new(sign_up_form_params)
    if @sign_up_form.save
      auto_login(@sign_up_form.user)
      flash[:success] = "ユーザー登録が完了しました"
      redirect_to root_path # 後にプロフィール詳細ページに移動するように変更
    else
      flash.now[:danger] = "ユーザー登録に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def sign_up_form_params
    params.require(:sign_up_form).permit(:email, :password, :password_confirmation, :name)
  end

end
