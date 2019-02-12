# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User Invitations", type: :request do
  describe "GET /users/invitation/new" do
    context "when a system user is signed in" do
      let(:user) { create(:user, :system) }
      before(:each) do
        sign_in(user)
      end

      it "renders the new template" do
        get "/users/invitation/new"
        expect(response).to render_template(:new)
      end
    end

    context "when a non-system user is signed in" do
      let(:user) { create(:user, :data_agent) }
      before(:each) do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        get "/users/invitation/new"
        expect(response).to redirect_to("/pages/permission")
      end
    end
  end

  describe "POST /users/invitation" do
    let(:email) { attributes_for(:user)[:email] }
    let(:role) { attributes_for(:user)[:role] }
    let(:params) do
      { user: { email: email, role: role } }
    end

    context "when a system user is signed in" do
      let(:user) { create(:user, :system) }
      before(:each) do
        sign_in(user)
      end

      it "redirects to the users path" do
        post "/users/invitation", params
        expect(response).to redirect_to(users_path)
      end

      it "creates a new user" do
        old_user_count = User.count

        post "/users/invitation", params
        expect(User.count).to eq(old_user_count + 1)
      end

      it "assigns the correct role to the user" do
        post "/users/invitation", params
        expect(User.find_by(email: email).role).to eq(role)
      end
    end

    context "when a non-system user is signed in" do
      let(:user) { create(:user, :data_agent) }
      before(:each) do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        post "/users/invitation", params
        expect(response).to redirect_to("/pages/permission")
      end
    end
  end
end
