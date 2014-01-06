require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "assigns a new User to @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "GET show" do
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 1 }
    end

    it "assigns the requested user to @user" do
      user = FactoryGirl.create(:user)
      set_current_user(user)
      get :show, id: user.id
      expect(assigns(:user)).to eq(user)
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

    context "sending welcome emails" do
      after { ActionMailer::Base.deliveries.clear }

      it "sends out email to the new user with valid attributes" do
        post :create, user: FactoryGirl.attributes_for(:user, email: "alice@example.com")
        expect(ActionMailer::Base.deliveries.last.to).to eq(["alice@example.com"])
      end

      it "sends out email containing the new user's full name with valid attributes" do
        post :create, user: FactoryGirl.attributes_for(:user, full_name: "Joe Smith")
        expect(ActionMailer::Base.deliveries.last.body).to include("Joe Smith")
      end

      it "does not send out email with invalid attributes" do
        post :create, user: FactoryGirl.attributes_for(:user, full_name: nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end
