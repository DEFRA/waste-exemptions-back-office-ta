# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Waste Exemptions Engine", type: :request do
  describe "/start/new" do
    context "when a valid user is signed in" do
      before { sign_in(create(:user)) }

      it "returns a 200 response" do
        get "/start/new"
        expect(response).to have_http_status(200)
      end
    end

    context "when a deactivated user is signed in" do
      before { sign_in(create(:user, :inactive)) }

      it "redirects to the deactivated page" do
        get "/start/new"
        expect(response).to redirect_to("/pages/deactivated")
      end
    end

    context "when a valid user is not signed in" do
      before { sign_out(create(:user)) }

      it "redirects to the sign-in page" do
        get "/start/new"
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
