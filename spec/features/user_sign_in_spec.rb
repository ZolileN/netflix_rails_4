require 'spec_helper'

feature "user signs in" do
  scenario "with valid email and password" do
    alice = FactoryGirl.create(:user)
    sign_in(alice)
    page.should have_content(alice.full_name)
  end
end
