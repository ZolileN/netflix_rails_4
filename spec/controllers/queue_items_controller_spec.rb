require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    let(:alice) { FactoryGirl.create(:user) }
    before { set_current_user(alice) }

    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end

    it "assigns the queue_items of the current user to @queue_items" do
      queue_item1 = FactoryGirl.create(:queue_item, user: alice)
      queue_item2 = FactoryGirl.create(:queue_item, user: alice)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end
  end

  describe "POST create" do
    let(:alice) { FactoryGirl.create(:user) }
    let(:video) { FactoryGirl.create(:video) }
    before { set_current_user(alice) }

    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end

    it "redirects to the my_queue page" do
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end

    it "saves a new queue_item in the database" do
      expect{
        post :create, video_id: video.id
      }.to change(QueueItem, :count).by(1)
    end

    it "saves the queue_item that is associated with the video" do
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end

    it "saves the queue_item that is associated with the current user" do
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(alice)
    end

    it "does not save the queue_item if the video is already in the queue" do
      FactoryGirl.create(:queue_item, video: video, user: alice)
      expect{
        post :create, video_id: video.id
      }.not_to change(QueueItem, :count)
    end
  end
end
