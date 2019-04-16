# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Edit Forms", type: :request do
    let(:user) { create(:user, :super_agent) }
    before(:each) do
      sign_in(user)
    end

    let(:form) { build(:edit_form) }

    describe "GET edit_form" do
      let(:request_path) { "/edit/#{form.token}" }

      it "renders the appropriate template" do
        get request_path
        expect(response).to render_template("waste_exemptions_engine/edit_forms/new")
      end

      it "responds to the GET request with a 200 status code" do
        get request_path
        expect(response.code).to eq("200")
      end

      context "when the token is a registration reference" do
        let(:registration) { create(:registration) }
        let(:request_path) { "/edit/#{registration.reference}" }

        it "renders the appropriate template" do
          get request_path
          expect(response).to render_template("waste_exemptions_engine/edit_forms/new")
        end

        it "responds to the GET request with a 200 status code" do
          get request_path
          expect(response.code).to eq("200")
        end

        it "loads the edit form for that registration" do
          get request_path
          expect(response.body).to include(registration.reference)
        end

        context "when the registration doesn't have an edit in progress" do
          it "creates a new EditedRegistration for the registration" do
            expect { get request_path }.to change { WasteExemptionsEngine::EditedRegistration.where(reference: registration.reference).count }.from(0).to(1)
          end
        end

        context "when the registration already has an edit in progress" do
          let(:edited_registration) { create(:edited_registration) }
          let(:request_path) { "/edit/#{edited_registration.reference}" }

          it "does not create a new EditedRegistration for the registration" do
            expect { get request_path }.to_not change { WasteExemptionsEngine::EditedRegistration.where(reference: edited_registration.reference).count }.from(1)
          end
        end
      end
    end

    describe "unable to go submit GET back" do
      let(:request_path) { "/edit/back/#{form.token}" }
      it "raises an error" do
        expect { get request_path }.to raise_error(ActionController::RoutingError)
      end
    end

    describe "POST start_form" do
      let(:request_path) { "/edit/" }
      let(:request_body) { { edit_form: { token: form.token } } }
      status_code = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE

      # A successful POST request redirects to the next form in the work flow. We have chosen to
      # differentiate 'good' rediection as 303 and 'bad' redirection as 302.
      it "responds to the POST request with a #{status_code} status code" do
        post request_path, request_body
        expect(response.code).to eq(status_code.to_s)
      end
    end
  end
end
