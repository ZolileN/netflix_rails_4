module ApplicationHelper
  def sign_in(user)
    session[:user_id] = user.id
  end

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    redirect_to sign_in_path unless current_user
  end
end
