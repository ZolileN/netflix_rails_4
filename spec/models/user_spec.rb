require 'spec_helper'

describe User do
  it { should have_secure_password }
  it { should validate_presence_of(:email) }
  # it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:full_name) }
  it { should have_many(:reviews) }
  it { should have_many(:queue_items) }

  describe "#queued_video?" do
    it "returns true when the user queued the video" do
      user = FactoryGirl.create(:user)
      video = FactoryGirl.create(:video)
      FactoryGirl.create(:queue_item, user: user, video: video)
      expect(user.queued_video?(video)).to be_true
    end

    it "returns false when the user hasn't queued the video" do
      user = FactoryGirl.create(:user)
      video = FactoryGirl.create(:video)
      expect(user.queued_video?(video)).to be_false
    end
  end
end
