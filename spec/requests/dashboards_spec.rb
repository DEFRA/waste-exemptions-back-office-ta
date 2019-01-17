# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboards", type: :request do
  describe "/" do
    context "when a valid user is signed in" do
      before { sign_in(create(:user)) }

      it "renders the index template" do
        get "/"
        expect(response).to render_template(:index)
      end

      it "returns a 200 response" do
        get "/"
        expect(response).to have_http_status(200)
      end
    end

    context "when a valid user is not signed in" do
      before { sign_out(create(:user)) }

      it "redirects to the sign-in page" do
        get "/"
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
