# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Confirmation Letter", type: :request do
  let(:registration) { create(:registration) }
  let(:user) { create(:user, :system) }
  before(:each) do
    sign_in(user)
  end

  describe "GET /confirmation-letter/:id" do
    it "responds with a PDF with a filename that includes the registration reference" do
      get confirmation_letter_path(registration.id)
      expect(response.content_type).to eq("application/pdf")
      expect(response.headers["Content-Disposition"]).to eq("inline; filename=\"#{registration.reference}_confirmation_letter.pdf\"")
    end

    context "when the 'show_as_html' query string is present" do
      context "and the value is 'true'" do
        it "responds with HTML" do
          get "#{confirmation_letter_path(registration.id)}?show_as_html=true"
          expect(response.content_type).to eq("text/html")
        end
      end

      [:false, 1, 0, :foo].each do |bad_value|
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
