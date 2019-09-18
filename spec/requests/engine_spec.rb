# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Waste Exemptions Engine", type: :request do
  describe "/start" do
    let(:request_path) { "/start" }

    context "when a valid user is signed in" do
      before { sign_in(create(:user, :admin_agent)) }

      it "returns a 200 response" do
        get request_path
        expect(response).to have_http_status(200)
      end
    end

    context "when a data_agent is signed in" do
      before { sign_in(create(:user, :data_agent)) }

      it "redirects to the permissions error page" do
        get request_path
        expect(response).to redirect_to("/pages/permission")
      end
    end

    context "when a deactivated user is signed in" do
      before { sign_in(create(:user, :inactive)) }

      it "redirects to the deactivated page" do
        get request_path
        expect(response).to redirect_to("/pages/deactivated")
      end
    end

    context "when a valid user is not signed in" do
      before { sign_out(create(:user)) }

      it "redirects to the sign-in page" do
        get request_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "edit permissions" do
    let(:registration) { create(:registration) }
    let(:request_path) { "/#{registration.reference}/edit" }

    context "when a valid user is signed in" do
      before { sign_in(create(:user, :super_agent)) }

      it "returns a 200 response" do
        get request_path
        expect(response).to have_http_status(200)
      end
    end

    context "when an admin_agent is signed in" do
      before { sign_in(create(:user, :admin_agent)) }

      it "redirects to the permissions error page" do
        get request_path
        expect(response).to redirect_to("/pages/permission")
      end
    end
  end
end
