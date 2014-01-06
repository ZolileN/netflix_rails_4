class ForgotPasswordsController < ApplicationController
  def create
    user = User.find_by(email: params[:email].downcase)
    if user
      AppMailer.send_forgot_password_email(user).deliver
      redirect_to forgot_password_confirmation_path
    else
      flash[:error] = params[:email].blank? ? "Email cannot be blank" : "There is no user with that email"
      render :new
    end
  end
end
