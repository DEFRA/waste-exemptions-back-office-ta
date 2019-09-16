# frozen_string_literal: true

require "rails_helper"

RSpec.describe "AD Renewal letters export", type: :request do
  let(:user) { create(:user, :system) }

  before(:each) do
    sign_in(user)
  end

  describe "GET /ad-renewal-letters" do
    it "renders the correct template" do
      get ad_renewal_letters_exports_path

      expect(response).to render_template("ad_renewal_letters_exports/index")
    end

    it "responds with a 200 status code" do
      get ad_renewal_letters_exports_path

      expect(response.code).to eq("200")
    end
  end

  describe "PUT /ad-renewal-letters" do
    let(:ad_renewal_letters_export) { create(:ad_renewal_letters_export) }
    let(:params) do
      {
        ad_renewal_letters_export: {
          printed_on: Date.today,
          printed_by: user.email
        }
      }
    end

    it "update the record" do
      put ad_renewal_letters_export_path(ad_renewal_letters_export), params

      ad_renewal_letters_export.reload

      expect(ad_renewal_letters_export.printed_on).to eq(Date.today)
      expect(ad_renewal_letters_export.printed_by).to eq(user.email)
    end

    it "redirect to the index path" do
      put ad_renewal_letters_export_path(ad_renewal_letters_export), params

      expect(response).to redirect_to(ad_renewal_letters_exports_path)
    end
  end
end
