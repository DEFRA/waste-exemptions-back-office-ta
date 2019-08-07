# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Renews", type: :request do
  let(:registration) { create(:registration) }

  describe "GET /renews/:reference" do
    let(:request_path) { "/renew/#{registration.reference}" }

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
        get request_path

        expect(response.code).to eq("303")
      end

      it "redirect to the renewal start form" do
        get request_path
        follow_redirect!

        expect(response).to render_template("waste_exemptions_engine/renewal_start_forms/new")
      end

      context "when the renewal was already started" do
        let(:renewing_registration) { create(:renewing_registration, workflow_state: "contact_name_form") }
        let(:registration) { renewing_registration.referring_registration }

        it "redirects to the correct template status" do
          get request_path
          follow_redirect!

          expect(response).to render_template("waste_exemptions_engine/contact_name_forms/new")
        end
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
