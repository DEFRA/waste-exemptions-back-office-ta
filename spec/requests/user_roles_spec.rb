# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User Roles", type: :request do
  let(:role_change_user) { create(:user, :data_agent) }
  let(:system_user) { create(:user, :system) }

  describe "GET /users/role/:id" do
    context "when a system user is signed in" do
      before(:each) do
        sign_in(system_user)
      end

      include_examples "Renders valid html" do
        let(:request_path) { "/users/role/#{role_change_user.id}" }
      end

      it "renders the edit template" do
        get "/users/role/#{role_change_user.id}"
        expect(response).to render_template(:edit)
      end
    end

    context "when a non-system user is signed in" do
      let(:user) { create(:user, :data_agent) }
      before(:each) do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        get "/users/role/#{role_change_user.id}"
        expect(response).to redirect_to("/pages/permission")
      end
    end
  end

  describe "POST /users/role" do
    let(:params) { { role: "admin_agent" } }

    context "when a system user is signed in" do
      before(:each) do
        sign_in(system_user)
      end

      it "updates the user role" do
        post "/users/role/#{role_change_user.id}", user: params
        expect(role_change_user.reload.role).to eq(params[:role])
      end

      it "redirects to the user list" do
        post "/users/role/#{role_change_user.id}", user: params
        expect(response).to redirect_to(users_path)
      end

      it "assigns the correct whodunnit to the version", versioning: true do
        post "/users/role/#{role_change_user.id}", user: params
        expect(role_change_user.reload.versions.last.whodunnit).to eq(system_user.id.to_s)
      end

      context "when the params are invalid" do
        let(:params) { { role: "foo" } }

        it "does not update the user role" do
          post "/users/role/#{role_change_user.id}", user: params
          expect(role_change_user.reload.role).to eq("data_agent")
        end

        it "renders the edit template" do
          post "/users/role/#{role_change_user.id}", user: params
          expect(response).to render_template(:edit)
        end
      end

      context "when the params are blank" do
        it "does not update the user role" do
          post "/users/role/#{role_change_user.id}"
          expect(role_change_user.reload.role).to eq("data_agent")
        end

        it "renders the edit template" do
          post "/users/role/#{role_change_user.id}"
          expect(response).to render_template(:edit)
        end
      end
    end

    context "when a non-system user is signed in" do
      let(:user) { create(:user, :data_agent) }
      before(:each) do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        post "/users/role/#{role_change_user.id}", user: params
        expect(response).to redirect_to("/pages/permission")
      end
    end
  end
end
