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
