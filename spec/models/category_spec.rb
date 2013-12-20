require 'spec_helper'

describe Category do
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should have_many(:videos) }

  describe "#recent_videos" do
    it "returns videos in a descending order for created_at" do
      comedies = Category.create!(name: "Comedies")
      family_guy = Video.create!(title: "Family Guy", created_at: 1.day.ago, description: "Talking dog", category: comedies)
      south_park = Video.create!(title: "South Park", description: "Hippy Kids", category: comedies)
      expect(comedies.recent_videos).to eq([south_park, family_guy])
    end

    it "returns all videos if there are less than 6 videos" do
      comedies = Category.create!(name: "Comedies")
      family_guy = Video.create!(title: "Family Guy", description: "Talking dog", category: comedies)
      south_park = Video.create!(title: "South Park", description: "Hippy Kids", category: comedies)
      expect(comedies.recent_videos.size).to eq(2)
    end

    it "returns 6 videos if there are more than 6 videos" do
      comedies = Category.create!(name: "Comedies")
      7.times { Video.create!(title: "foo", description: "bar", category: comedies) }
      expect(comedies.recent_videos.size).to eq(6)
    end

    it "returns the latest 6 videos" do
      comedies = Category.create!(name: "Comedies")
      family_guy = Video.create!(title: "Family Guy", created_at: 1.day.ago, description: "Talking dog", category: comedies)
      6.times { Video.create!(title: "foo", description: "bar", category: comedies) }
      expect(comedies.recent_videos).not_to include(family_guy)
    end

    it "returns an empty array if there are no videos" do
      comedies = Category.create!(name: "Comedies")
      expect(comedies.recent_videos).to eq([])
    end
  end
end
