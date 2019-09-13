# frozen_string_literal: true

require "rails_helper"

RSpec.describe AdRenewalLettersExportsHelper, type: :helper do
  describe "#format_email_to_name" do
    it "takes an email and format it into a new string" do
      expect(helper.format_email_to_name("super_agent@wex.gov.uk")).to eq("Super Agent")
    end
  end
end
