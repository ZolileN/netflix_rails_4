require 'spec_helper'

describe RelationshipsController do
  describe "GET index" do
    let(:alice) { FactoryGirl.create(:user) }
    let(:bob) { FactoryGirl.create(:user, email: "bob@example.com") }

    before { set_current_user(alice) }

    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end

    it "assigns the current user's followed users to @followed_users" do
      relationship = Relationship.create(followed: bob, follower: alice)
      get :index
      expect(assigns(:followed_users)).to eq([relationship.followed])
    end
  end
end
