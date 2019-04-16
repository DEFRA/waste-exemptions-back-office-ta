# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Confirmation Letter", type: :request do
  let(:registration) { create(:registration) }
  let(:partnership_registration) { create(:registration, :partnership) }
  let(:user) { create(:user, :system) }
  before(:each) do
    sign_in(user)
  end

  describe "GET /confirmation-letter/:id" do

    # The presenter has branching logic for partnerships so this needs to be tested explicitly
    context "when the registration is for a partnership" do
      it "responds with a PDF" do
        get confirmation_letter_path(registration.id)
        expect(response.content_type).to eq("application/pdf")
      end

      it "returns a 200 status code" do
        get confirmation_letter_path(partnership_registration.id)
        expect(response.code).to eq("200")
      end
    end

    it "responds with a PDF with a filename that includes the registration reference" do
      get confirmation_letter_path(registration.id)
      expect(response.content_type).to eq("application/pdf")
      expected_content_disposition = "inline; filename=\"#{registration.reference}.pdf\""
      expect(response.headers["Content-Disposition"]).to eq(expected_content_disposition)
    end

    it "returns a 200 status code" do
      get confirmation_letter_path(registration.id)
      expect(response.code).to eq("200")
    end

    context "when the 'show_as_html' query string is present" do
      context "and the value is 'true'" do
        it "responds with HTML" do
          get "#{confirmation_letter_path(registration.id)}?show_as_html=true"
          expect(response.content_type).to eq("text/html")
        end
      end

      [false, 1, 0, :foo].each do |bad_value|
        context "and the value is '#{bad_value}'" do
          it "responds with a PDF" do
            get "#{confirmation_letter_path(registration.id)}?show_as_html=#{bad_value}"
            expect(response.content_type).to eq("application/pdf")
          end
        end
      end
    end
  end
end
