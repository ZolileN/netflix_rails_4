require 'spec_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    context "with blank email" do
      it "renders the :new template" do
        post :create, email: ""
        expect(response).to render_template :new
      end

      it "shows the flash error messages" do
        post :create, email: ""
        expect(flash[:error]).to eq("Email cannot be blank")
      end
    end

    context "with existing user" do
      before { FactoryGirl.create(:user, email: "alice@example.com") }

      it "redirects to the forgot password confirmation page" do
        post :create, email: "alice@example.com"
        expect(response).to redirect_to forgot_password_confirmation_path
      end

      it "sends out an email to the email address" do
        post :create, email: "alice@example.com"
        expect(ActionMailer::Base.deliveries.last.to).to eq(["alice@example.com"])
      end
    end

    context "with non-existing user" do
      it "renders the :new template" do
        post :create, email: "alice@example.com"
        expect(response).to render_template :new
      end

      it "shows the flash error messages" do
        post :create, email: "alice@example.com"
        expect(flash[:error]).to eq("There is no user with that email")
      end
    end
  end
end
