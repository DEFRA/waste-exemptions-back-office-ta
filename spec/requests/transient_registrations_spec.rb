# frozen_string_literal: true

require "rails_helper"

RSpec.describe "TransientRegistrations", type: :request do
  let(:transient_registration) { create(:transient_registration) }

  describe "GET /transient-registrations/:id" do
    context "when a user is signed in" do
      before(:each) do
        sign_in(create(:user))
      end

      it "renders the show template" do
        get "/transient-registrations/#{transient_registration.id}"
        expect(response).to render_template(:show)
      end

      it "includes the correct reference" do
        get "/transient-registrations/#{transient_registration.id}"
        expect(response.body).to include(transient_registration.reference)
      end
    end
  end
end
