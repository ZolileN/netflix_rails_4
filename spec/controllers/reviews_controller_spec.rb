require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    let(:video) { FactoryGirl.create(:video) }
    let(:alice) { FactoryGirl.create(:user) }
    before { set_current_user(alice) }

    it_behaves_like "requires sign in" do
      let(:action) { post :create, review: FactoryGirl.attributes_for(:review), video_id: video.id }
    end

    context "with valid attributes" do
      it "redirects to the video page" do
        post :create, review: FactoryGirl.attributes_for(:review), video_id: video.id
        expect(response).to redirect_to video_path(video)
      end

      it "saves the new review in the database" do
        expect{
          post :create, review: FactoryGirl.attributes_for(:review), video_id: video.id
        }.to change(Review, :count).by(1)
      end

      it "saves the new review that is associated with the video" do
        post :create, review: FactoryGirl.attributes_for(:review), video_id: video.id
        expect(Review.first.video).to eq(video)
      end

      it "saves the new review that is associated with the current user" do
        post :create, review: FactoryGirl.attributes_for(:review), video_id: video.id
        expect(Review.first.user).to eq(alice)
      end
    end

    context "with invalid attributes" do
      it "re-renders the video template" do
        post :create, review: FactoryGirl.attributes_for(:review, rating: nil), video_id: video.id
        expect(response).to render_template 'videos/show'
      end

      it "does not save the new review in the database" do
        expect{
          post :create, review: FactoryGirl.attributes_for(:review, rating: nil), video_id: video.id
        }.not_to change(Review, :count)
      end

      it "assigns the requested video to @video" do
        post :create, review: FactoryGirl.attributes_for(:review, rating: nil), video_id: video.id
        expect(assigns(:video)).to eq(video)
      end

      it "reloads the reviews of the video" do
        review1 = FactoryGirl.create(:review, video: video)
        review2 = FactoryGirl.create(:review, video: video)
        post :create, review: FactoryGirl.attributes_for(:review, rating: nil), video_id: video.id
        expect(assigns(:reviews)).to match_array([review1, review2])
      end
    end
  end
end
