# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Registrations", type: :request do
  let(:registration) { create(:registration) }

  describe "GET /registrations/:id" do
    context "when a user is signed in" do
      before(:each) do
        sign_in(create(:user))
      end

      it "renders the show template" do
        get "/registrations/#{registration.id}"
        expect(response).to render_template(:show)
      end
    end
  end
end
