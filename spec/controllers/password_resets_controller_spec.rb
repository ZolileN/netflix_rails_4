require 'spec_helper'

describe PasswordResetsController do
  describe "GET show" do
    let(:alice) { FactoryGirl.create(:user) }

    it "renders the :show template if the token is valid" do
      alice.update_column(:token, "12345")
      get :show, id: "12345"
      expect(response).to render_template :show
    end

    it "assigns the requested token to @token" do
      alice.update_column(:token, "12345")
      get :show, id: "12345"
      expect(assigns(:token)).to eq("12345")
    end

    it "redirects to the expired token page if the token is not valid" do
      alice.update_column(:token, "12345")
      get :show, id: "abcba"
      expect(response).to redirect_to expired_token_path
    end
  end

  describe "POST create" do
    let(:alice) { FactoryGirl.create(:user, password: "old_password", password_confirmation: "old_password") }

    context "with valid token" do
      it "redirects to the user sign in page" do
        alice.update_column(:token, "12345")
        post :create, token: "12345", password: "new_password"
        expect(response).to redirect_to sign_in_path
      end

      it "updates the user's password" do
        alice.update_column(:token, "12345")
        post :create, token: "12345", password: "new_password"
        expect(alice.reload.authenticate("new_password")).to be_true
      end

      it "shows the flash error messages" do
        alice.update_column(:token, "12345")
        post :create, token: "12345", password: "new_password"
        expect(flash[:success]).to be_present
      end

      it "regenerates the user token" do
        alice.update_column(:token, "12345")
        post :create, token: "12345", password: "new_password"
        expect(alice.reload.token).not_to eq("12345")
      end
    end

    context "with invalid token" do
      it "redirects to the expired token page" do
        alice.update_column(:token, "12345")
        post :create, token: "abcba", password: "another_password"
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end
