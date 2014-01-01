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
end
