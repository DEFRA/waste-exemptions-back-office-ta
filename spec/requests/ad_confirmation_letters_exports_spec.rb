# frozen_string_literal: true

require "rails_helper"

RSpec.describe "AD Confirmation letters export", type: :request do
  let(:user) { create(:user, :system) }

  before(:each) do
    sign_in(user)
  end

  describe "GET /ad-confirmation-letters" do
    it "renders the correct template" do
      get ad_confirmation_letters_exports_path

      expect(response).to render_template("ad_confirmation_letters_exports/index")
    end

    it "responds with a 200 status code" do
      get ad_confirmation_letters_exports_path

      expect(response.code).to eq("200")
    end
  end

  describe "PUT /ad-confirmation-letters" do
    let(:ad_confirmation_letters_export) { create(:ad_confirmation_letters_export) }
    let(:params) do
      {
        ad_confirmation_letters_export: {
          printed_on: Date.today,
          printed_by: user.email
        }
      }
    end

    it "update the record" do
      put ad_confirmation_letters_export_path(ad_confirmation_letters_export), params

      ad_confirmation_letters_export.reload

      expect(ad_confirmation_letters_export.printed_on).to eq(Date.today)
      expect(ad_confirmation_letters_export.printed_by).to eq(user.email)
    end

    it "redirect to the index path" do
      put ad_confirmation_letters_export_path(ad_confirmation_letters_export), params

      expect(response).to redirect_to(ad_confirmation_letters_exports_path)
    end
  end
end
