# frozen_string_literal: true

require "rails_helper"
require "waste_exemptions_engine/exceptions/unsubmittable_form"

module WasteExemptionsEngine
  RSpec.describe "Edit Complete Forms", type: :request do
    let(:user) { create(:user, :super_agent) }
    before(:each) do
      sign_in(user)
    end

    let(:form) { build(:edit_complete_form) }

    describe "GET edit_complete_form" do
      let(:request_path) { "/edit-complete/#{form.token}" }

      it "renders the appropriate template" do
        get request_path
        expect(response).to render_template("waste_exemptions_engine/edit_complete_forms/new")
      end

      it "responds to the GET request with a 200 status code" do
        get request_path
        expect(response.code).to eq("200")
      end
    end

    describe "unable to go submit GET back" do
      let(:request_path) { "/edit-complete/back/#{form.token}" }
      it "raises an error" do
        expect { get request_path }.to raise_error(ActionController::RoutingError)
      end
    end

    describe "POST edit_complete_form back" do
      let(:post_request_path) { "/edit-complete" }
      let(:request_body) { { edit_complete_form: { token: form.token } } }

      it "raises an UnsubmittableForm error" do
        expect { post post_request_path, request_body }.to raise_error do |error|
          allowed_errors = [
            WasteExemptionsEngine::UnsubmittableForm,
            ActionController::RoutingError,
            ActionView::MissingTemplate,
            AASM::InvalidTransition
          ]
          expect(error.class).to be_in(allowed_errors)
        end
      end
    end
  end
end
