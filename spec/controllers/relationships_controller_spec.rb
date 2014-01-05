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

  describe "POST create" do
    let(:alice) { FactoryGirl.create(:user) }
    let(:bob) { FactoryGirl.create(:user, email: "bob@example.com") }

    before { set_current_user(alice) }

    it_behaves_like "requires sign in" do
      let(:action) { post :create, followed_id: 4 }
    end

    it "redirects to the people page" do
      post :create, followed_id: bob.id
      expect(response).to redirect_to people_path
    end

    it "saves a relationship that the current user follows the user" do
      post :create, followed_id: bob.id
      expect(Relationship.first.followed).to eq(bob)
    end

    it "does not save a relationship if the current user already followed the user" do
      Relationship.create(followed: bob, follower: alice)
      expect{
        post :create, followed_id: bob.id
      }.not_to change(Relationship, :count)
    end

    it "does not allow current user to follow themselves" do
      expect{
        post :create, followed_id: alice.id
      }.not_to change(Relationship, :count)
    end
  end

  describe "DELETE destroy" do
    let(:alice) { FactoryGirl.create(:user) }
    let(:bob) { FactoryGirl.create(:user, email: "bob@example.com") }

    before { set_current_user(alice) }

    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 4 }
    end

    it "redirects to the people page" do
      relationship = Relationship.create(followed: bob, follower: alice)
      delete :destroy, id: relationship.id
      expect(response).to redirect_to people_path
    end

    it "deletes the relationship if the current user is the follower" do
      relationship = Relationship.create(followed: bob, follower: alice)
      expect{
        delete :destroy, id: relationship.id
      }.to change(Relationship, :count).by(-1)
    end

    it "does not delete the relationship if the current user is not the follower" do
      dan = FactoryGirl.create(:user, email: "dan@example.com")
      relationship = Relationship.create(followed: bob, follower: dan)
      expect{
        delete :destroy, id: relationship.id
      }.not_to change(Relationship, :count)
    end
  end
end
