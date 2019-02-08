# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User Activations", type: :request do
  let(:active_user) { create(:user) }
  let(:inactive_user) { create(:user, :inactive) }

  describe "GET /users/activate/:id" do
    context "when a system user is signed in" do
      let(:user) { create(:user, :system) }
      before(:each) do
        sign_in(user)
      end

      context "when the user to be activated is inactive" do
        it "renders the activate_form template" do
          get "/users/activate/#{inactive_user.id}"
          expect(response).to render_template(:activate_form)
        end
      end

      context "when the user to be activated is already active" do
        it "redirects to the user list" do
          get "/users/activate/#{active_user.id}"
          expect(response).to redirect_to(users_path)
        end
      end
    end
  end

  describe "GET /users/deactivate/:id" do
    context "when a system user is signed in" do
      let(:user) { create(:user, :system) }
      before(:each) do
        sign_in(user)
      end

      context "when the user to be deactivated is active" do
        it "renders the deactivate_form template" do
          get "/users/deactivate/#{active_user.id}"
          expect(response).to render_template(:deactivate_form)
        end
      end

      context "when the user to be deactivated is already inactive" do
        it "redirects to the user list" do
          get "/users/deactivate/#{inactive_user.id}"
          expect(response).to redirect_to(users_path)
        end
      end
    end
  end

  describe "POST /users/activate" do
    context "when a system user is signed in" do
      let(:user) { create(:user, :system) }
      before(:each) do
        sign_in(user)
      end

      context "when the user to be activated is inactive" do
        it "redirects to the user list" do
          post "/users/activate/#{inactive_user.id}"
          expect(response).to redirect_to(users_path)
        end

        it "activates the user" do
          post "/users/activate/#{inactive_user.id}"
          expect(inactive_user.reload.active?).to eq(true)
        end
      end

      context "when the user to be activated is already active" do
        it "redirects to the user list" do
          post "/users/activate/#{active_user.id}"
          expect(response).to redirect_to(users_path)
        end
      end
    end
  end

  describe "POST /users/deactivate" do
    context "when a system user is signed in" do
      let(:user) { create(:user, :system) }
      before(:each) do
        sign_in(user)
      end

      context "when the user to be deactivated is active" do
        it "redirects to the user list" do
          post "/users/deactivate/#{active_user.id}"
          expect(response).to redirect_to(users_path)
        end

        it "deactivates the user" do
          post "/users/deactivate/#{active_user.id}"
          expect(active_user.reload.active?).to eq(false)
        end
      end

      context "when the user to be deactivated is already inactive" do
        it "redirects to the user list" do
          post "/users/deactivate/#{inactive_user.id}"
          expect(response).to redirect_to(users_path)
        end
      end
    end
  end
end
