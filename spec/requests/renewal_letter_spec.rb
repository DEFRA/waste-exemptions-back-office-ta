# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Renewal Letter", type: :request do
  let(:registration) { create(:registration, :with_active_exemptions) }
  let(:user) { create(:user, :system) }
  before(:each) do
    sign_in(user)
  end

  describe "GET /renewal-letter/:id" do
    it "responds with a PDF with a filename that includes the registration reference" do
      get renewal_letter_path(registration.id)

      expect(response.content_type).to eq("application/pdf")
      expected_content_disposition = "inline; filename=\"#{registration.reference}.pdf\"; filename*=UTF-8''#{registration.reference}.pdf"
      expect(response.headers["Content-Disposition"]).to eq(expected_content_disposition)
    end

    context "when the registration is a charity" do
      let(:registration) { create(:registration, :charity, :with_active_exemptions) }

      it "returns a 200 status code" do
        get renewal_letter_path(registration.id)

        expect(response.code).to eq("200")
      end
    end

    context "when the registration is a limited company" do
      let(:registration) { create(:registration, :limited_company, :with_active_exemptions) }

      it "returns a 200 status code" do
        get renewal_letter_path(registration.id)

        expect(response.code).to eq("200")
      end
    end

    context "when the registration is an LLP" do
      let(:registration) { create(:registration, :limited_liability_partnership, :with_active_exemptions) }

      it "returns a 200 status code" do
        get renewal_letter_path(registration.id)

        expect(response.code).to eq("200")
      end
    end

    context "when the registration is a local authority" do
      let(:registration) { create(:registration, :local_authority, :with_active_exemptions) }

      it "returns a 200 status code" do
        get renewal_letter_path(registration.id)

        expect(response.code).to eq("200")
      end
    end

    context "when the registration is a partnership" do
      let(:registration) { create(:registration, :partnership, :with_active_exemptions) }

      it "returns a 200 status code" do
        get renewal_letter_path(registration.id)

        expect(response.code).to eq("200")
      end
    end

    context "when the registration is a sole trader" do
      let(:registration) { create(:registration, :sole_trader, :with_active_exemptions) }

      it "returns a 200 status code" do
        get renewal_letter_path(registration.id)

        expect(response.code).to eq("200")
      end
    end

    context "when the 'show_as_html' query string is present" do
      context "and the value is 'true'" do
        it "responds with HTML" do
          get "#{renewal_letter_path(registration.id)}?show_as_html=true"

          expect(response.content_type).to eq("text/html; charset=utf-8")
        end
      end

      [false, 1, 0, :foo].each do |bad_value|
        context "and the value is '#{bad_value}'" do
          it "responds with a PDF" do
            get "#{renewal_letter_path(registration.id)}?show_as_html=#{bad_value}"

            expect(response.content_type).to eq("application/pdf")
          end
        end
      end
    end
  end
end
