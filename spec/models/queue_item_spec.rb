require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }

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
end
