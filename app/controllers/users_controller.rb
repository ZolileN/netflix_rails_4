class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
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