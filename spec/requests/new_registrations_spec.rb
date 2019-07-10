# frozen_string_literal: true

require "rails_helper"

RSpec.describe "NewRegistrations", type: :request do
  let(:new_registration) { create(:new_registration) }

  describe "GET /new-registrations/:id" do
    context "when a user is signed in" do
      before(:each) do
        sign_in(create(:user))
      end

      it "renders the show template" do
        get "/new-registrations/#{new_registration.id}"
        expect(response).to render_template(:show)
      end
    end

    context "when a valid user is not signed in" do
      before { sign_out(create(:user)) }

      it "redirects to the sign-in page" do
        get "/new-registrations/#{new_registration.id}"
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
