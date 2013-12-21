require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "assigns a new User to @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST create" do
    context "with valid attributes" do
      it "saves the new user in the database" do
        expect{
          post :create, user: FactoryGirl.attributes_for(:user)
        }.to change(User, :count).by(1)
      end

      it "redirects to the homepage" do
        post :create, user: FactoryGirl.attributes_for(:user)
        expect(response).to redirect_to home_path
      end

      it "shows the notice messages" do
        post :create, user: FactoryGirl.attributes_for(:user)
        expect(flash[:notice]).to be_present
      end
    end

    context "with invalid attributes" do
      it "does not save the new user in the database" do
        expect{
          post :create, user: FactoryGirl.attributes_for(:user, full_name: nil)
        }.not_to change(User, :count)
      end

      it "re-renders the :new template" do
        post :create, user: FactoryGirl.attributes_for(:user, full_name: nil)
        expect(response).to render_template :new
      end
    end
  end
end
