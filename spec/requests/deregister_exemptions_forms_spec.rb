# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Deregister Exemptions Forms", type: :request do
  let(:form) { DeregisterExemptionsForm.new }
  let(:active_registration_exemption) do
    reg_exemption = create(:registration).registration_exemptions.first
    reg_exemption.state = "active"
    reg_exemption.save!
    reg_exemption
  end
  let(:inactive_registration_exemption) do
    reg_exemption = create(:registration).registration_exemptions.first
    reg_exemption.state = "revoked"
    reg_exemption.save!
    reg_exemption
  end
  let(:good_request_path) { "/registration-exemptions/deregister/#{active_registration_exemption.id}" }
  let(:bad_request_path) { "/registration-exemptions/deregister/#{inactive_registration_exemption.id}" }

  let(:user) { create(:user, :super_agent) }
  before(:each) do
    sign_in(user)
  end

  describe "GET /registration_exemptions/deregister/:id" do
    context "when the registration_exemption can be deregistered by the current_user" do
      it "renders the appropriate template" do
        get good_request_path
        expect(response).to render_template("deregister_exemptions/new")
      end

      it "responds to the GET request with a 200 status code" do
        get good_request_path
        expect(response.code).to eq("200")
      end
    end

    context "when the registration_exemption can not be deregistered by the current_user" do
      status_code = WasteExemptionsEngine::ApplicationController::UNSUCCESSFUL_REDIRECTION_CODE

      it "renders the appropriate template" do
        get bad_request_path
        expect(response.location).to include("/pages/permission")
      end

      it "responds to the GET request with a #{status_code} status code" do
        get bad_request_path
        expect(response.code).to eq(status_code.to_s)
      end
    end
  end

  describe "POST /registration_exemptions/deregister/:id" do
    let(:request_body) do
      { deregister_exemptions_form: { state_transition: "revoke", message: "This exemption is no longer relevant" } }
    end

    context "when the registration_exemption can be deregistered by the current_user" do
      context "and the form is valid" do
        status_code = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE

        it "renders the registration template" do
          post good_request_path, request_body
          expect(response.location).to include("registrations/#{active_registration_exemption.registration.reference}")
        end

        it "responds to the POST request with a #{status_code} status code" do
          post good_request_path, request_body
          expect(response.code).to eq(status_code.to_s)
        end

        it "updates the registration_exemption state" do
          reg_exemp_id = active_registration_exemption.id
          before_post_record = WasteExemptionsEngine::RegistrationExemption.find(reg_exemp_id)
          expect(before_post_record.state).to eq("active")
          expect(before_post_record.deregistration_message).to be_blank

          post good_request_path, request_body

          form_data = request_body[:deregister_exemptions_form]
          after_post_record = WasteExemptionsEngine::RegistrationExemption.find(reg_exemp_id)
          expect(after_post_record.state).to eq("#{form_data[:state_transition]}d")
          expect(after_post_record.deregistration_message).to eq(form_data[:message])
        end
      end

      context "and the form is not valid" do
        let(:invalid_request_body) do
          { deregister_exemptions_form: { state_transition: "deativate", message: "foo" } }
        end

        it "renders the same template" do
          post good_request_path, invalid_request_body
          expect(response).to render_template("deregister_exemptions/new")
        end

        it "responds to the POST request with a 200 status code" do
          post good_request_path, invalid_request_body
          expect(response.code).to eq("200")
        end
      end
    end

    context "when the registration_exemption can not be deregistered by the current_user" do
      status_code = WasteExemptionsEngine::ApplicationController::UNSUCCESSFUL_REDIRECTION_CODE

      it "renders the appropriate template" do
        post bad_request_path, request_body
        expect(response.location).to include("/pages/permission")
      end

      it "responds to the POST request with a #{status_code} status code" do
        post bad_request_path, request_body
        expect(response.code).to eq(status_code.to_s)
      end
    end
  end
end
