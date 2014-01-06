def set_current_user(user=nil)
  session[:user_id] = (user || FactoryGirl.create(:user)).id
end

def sign_in(a_user=nil)
  user = a_user || FactoryGirl.create(:user)
  visit sign_in_path
  fill_in "Email Address", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def click_video_on_home_page(video)
  find("a[href='/videos/#{video.id}']").click
end
