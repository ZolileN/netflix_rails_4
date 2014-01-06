class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      AppMailer.send_welcome_email(@user).deliver
      redirect_to home_path, notice: "You are signed in, enjoy!"
    else
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :full_name, :password, :password_confirmation)
  end
end
