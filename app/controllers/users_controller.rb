class UsersController < ApplicationController
  before_action :set_card

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = current_user
    if avatar_delete_check[:avatar_delete_instruction] == "run"
      if @user.update(user_params)
        @user.remove_avatar!
        @user.save
        redirect_to root_path, notice: "登録情報が変更されました。"
      else
        flash.now[:alert] = "登録情報が変更できませんでした。"
        render :edit
      end
    else
      if @user.update(user_params)
        redirect_to root_path, notice: "登録情報が変更されました。"
      else
        flash.now[:alert] = "登録情報が変更できませんでした。"
        render :edit
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:avatar, :avatar_cache, :nickname, :email)
  end
  
  def avatar_delete_check
    params.require(:user).permit(:avatar_delete_instruction)
  end
end
