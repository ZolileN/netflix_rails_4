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
      let(:action) { post :create, video_id: video.id }
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

    it "puts the video as the last one in the queue" do
      FactoryGirl.create(:queue_item, position: 1, video: video, user: alice)
      south_park = FactoryGirl.create(:video)
      post :create, video_id: south_park.id
      south_park_queue_item = QueueItem.find_by(video_id: south_park.id, user_id: alice.id)
      expect(south_park_queue_item.position).to eq(2)
    end

    it "does not save the queue_item if the video is already in the queue" do
      FactoryGirl.create(:queue_item, video: video, user: alice)
      expect{
        post :create, video_id: video.id
      }.not_to change(QueueItem, :count)
    end
  end

  describe "DELETE destroy" do
    let(:alice) { FactoryGirl.create(:user) }
    before { set_current_user(alice) }

    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 3 }
    end

    it "redirects to the my_queue page" do
      queue_item = FactoryGirl.create(:queue_item, user: alice)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end

    it "deletes the queue_item" do
      queue_item = FactoryGirl.create(:queue_item, user: alice)
      expect{
        delete :destroy, id: queue_item.id
      }.to change(QueueItem, :count).by(-1)
    end

    it "norializes the remaining queue items" do
      queue_item1 = FactoryGirl.create(:queue_item, position: 1, user: alice)
      queue_item2 = FactoryGirl.create(:queue_item, position: 2, user: alice)
      delete :destroy, id: queue_item1.id
      expect(queue_item2.reload.position).to eq(1)
    end

    it "does not delete the queue_item if queue_item isnot associated with the current user" do
      bob = FactoryGirl.create(:user, email: "rails@example.com")
      queue_item = FactoryGirl.create(:queue_item, user: bob)
      expect{
        delete :destroy, id: queue_item.id
      }.not_to change(QueueItem, :count)
    end
  end

  describe "POST update_queue" do
    it_behaves_like "requires sign in" do
      let(:action) { post :update_queue, queue_items: [{id: 1, position: 3}, {id: 2, position: 2}] }
    end

    context "with valid attributes" do
      let(:alice) { FactoryGirl.create(:user) }
      let(:video) { FactoryGirl.create(:video) }
      let(:queue_item1) { FactoryGirl.create(:queue_item, position: 1, user: alice, video: video) }
      let(:queue_item2) { FactoryGirl.create(:queue_item, position: 2, user: alice, video: video) }

      before { set_current_user(alice) }

      it "redirects to the my_queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "reorders the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(alice.queue_items).to eq([queue_item2, queue_item1])
      end

      it "normalizes the position numbers" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(alice.queue_items.map(&:position)).to eq([1, 2])
      end
    end

    context "with invalid attributes" do
      let(:alice) { FactoryGirl.create(:user) }
      let(:video) { FactoryGirl.create(:video) }
      let(:queue_item1) { FactoryGirl.create(:queue_item, position: 1, user: alice, video: video) }
      let(:queue_item2) { FactoryGirl.create(:queue_item, position: 2, user: alice, video: video) }

      before { set_current_user(alice) }

      it "redirects to the my_queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2}]
        expect(response).to redirect_to my_queue_path
      end

      it "shows the flash error message" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2}]
        expect(flash[:error]).to be_present
      end

      it "does not change the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2.1}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end

    context "with queue items that do not belong to the current user" do
      it "does not change the queue items" do
        alice = FactoryGirl.create(:user)
        john = FactoryGirl.create(:user, email: "john@example.com")
        video = FactoryGirl.create(:video)
        queue_item1 = FactoryGirl.create(:queue_item, position: 1, user: john, video: video)
        queue_item2 = FactoryGirl.create(:queue_item, position: 2, user: alice, video: video)
        set_current_user(alice)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
  end
end
