require 'spec_helper'

describe VideosController do
  describe "GET show" do
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 1 }
    end

    it "assigns the requested video to @video" do
      video = FactoryGirl.create(:video)
      set_current_user
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end
  end

  describe "GET search" do
    it_behaves_like "requires sign in" do
      let(:action) { post :search, search_term: "q" }
    end

    it "assigns the requested videos to @result" do
      video1 = FactoryGirl.create(:video, title: "Futurama", created_at: 1.day.ago)
      video2 = FactoryGirl.create(:video, title: "Back to Future")
      set_current_user
      post :search, search_term: "utur"
      expect(assigns(:result)).to eq([video2, video1])
    end
  end
end
