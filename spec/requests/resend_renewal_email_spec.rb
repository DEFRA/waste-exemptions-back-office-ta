# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ResendRenewalEmail", type: :request do
  let(:registration) { create(:registration) }

  describe "GET /resend-renewal-email/:reference" do
    let(:request_path) { "/resend-renewal-email/#{registration.reference}" }

    before(:each) do
      sign_in(user) if defined?(user)
    end

    context "when a data agent user is signed in" do
      let(:user) { create(:user, :data_agent) }

      it "redirects to permission page" do
        get request_path
        follow_redirect!

        expect(response).to render_template("pages/permission")
      end
    end

    context "when an admin agent user is signed in" do
      let(:user) { create(:user, :admin_agent) }

      it "return a 303 redirect code" do
        get request_path, {}, "HTTP_REFERER" => "https://example.com"

        expect(response.code).to eq("302")
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
end
