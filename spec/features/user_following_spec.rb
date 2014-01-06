require 'spec_helper'

feature "User following" do
  scenario "users follows and unfollows another user" do
    alice = FactoryGirl.create(:user, full_name: "Alice", email: "alice@example.com")
    category = FactoryGirl.create(:category)
    video = FactoryGirl.create(:video, category: category)
    review = FactoryGirl.create(:review, video: video, user: alice)

    sign_in
    click_video_on_home_page(video)

    click_link alice.full_name
    click_link "Follow"
    expect(page).to have_content(alice.full_name)

    unfollow(alice)
    expect(page).not_to have_content(alice.full_name)
  end

  def unfollow(user)
    find("a[href='/relationships/#{user.id}']").click
  end
end
