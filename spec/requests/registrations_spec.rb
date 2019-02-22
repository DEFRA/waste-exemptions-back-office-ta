# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Registrations", type: :request do
  let(:registration) { create(:registration) }

  describe "GET /registrations/:reference" do
    context "when a user is signed in" do
      before(:each) do
        sign_in(create(:user))
      end

      it "renders the show template" do
        get "/registrations/#{registration.reference}"
        expect(response).to render_template(:show)
      end

      it "includes the correct reference" do
        get "/registrations/#{registration.reference}"
        expect(response.body).to include(registration.reference)
      end
    end

    context "when a valid user is not signed in" do
      before { sign_out(create(:user)) }

      it "redirects to the sign-in page" do
        get "/registrations/#{registration.id}"
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
