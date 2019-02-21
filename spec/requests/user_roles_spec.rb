# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User Roles", type: :request do
  let(:role_change_user) { create(:user) }

  describe "GET /users/role/:id" do
    context "when a system user is signed in" do
      before(:each) do
        sign_in(create(:user, :system))
      end

      it "renders the edit template" do
        get "/users/role/#{role_change_user.id}"
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "POST /users/role" do
    context "when a system user is signed in" do
      before(:each) do
        sign_in(create(:user, :system))
      end

      it "redirects to the user list" do
        post "/users/role/#{role_change_user.id}"
        expect(response).to redirect_to(users_path)
      end
    end
  end
end
