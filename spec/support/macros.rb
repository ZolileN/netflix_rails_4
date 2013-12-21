def set_current_user(user=nil)
  session[:user_id] = (user || FactoryGirl.create(:user)).id
end
