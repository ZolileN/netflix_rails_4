require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_numericality_of(:position).only_integer }

  describe "#video_title" do
    it "returns the title of the associated video" do
      monk = FactoryGirl.create(:video, title: "Monk")
      queue_item = FactoryGirl.create(:queue_item, video: monk)
      expect(queue_item.video_title).to eq("Monk")
    end
  end

  describe "#category_name" do
    it "returns the name of the associated video's category" do
      comedies = FactoryGirl.create(:category, name: "Comedies")
      monk = FactoryGirl.create(:video, category: comedies)
      queue_item = FactoryGirl.create(:queue_item, video: monk)
      expect(queue_item.category_name).to eq("Comedies")
    end
  end

  describe "#category" do
    it "returns category of the associated video" do
      comedies = FactoryGirl.create(:category)
      monk = FactoryGirl.create(:video, category: comedies)
      queue_item = FactoryGirl.create(:queue_item, video: monk)
      expect(queue_item.category).to eq(comedies)
    end
  end

  describe "#rating" do
    it "returns the rating from the review when the review is present" do
      alice = FactoryGirl.create(:user)
      video = FactoryGirl.create(:video)
      review = FactoryGirl.create(:review, rating: 4, video: video, user: alice)
      queue_item = FactoryGirl.create(:queue_item, user: alice, video: video)
      expect(queue_item.rating).to eq(4)
    end

    it "returns nil when the review is not present" do
      alice = FactoryGirl.create(:user)
      video = FactoryGirl.create(:video)
      queue_item = FactoryGirl.create(:queue_item, user: alice, video: video)
      expect(queue_item.rating).to be_nil
    end
  end
end
