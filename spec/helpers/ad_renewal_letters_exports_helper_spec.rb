# frozen_string_literal: true

require "rails_helper"

RSpec.describe AdRenewalLettersExportsHelper, type: :helper do
  describe "#format_email_to_name" do
    it "takes an email and returns a string formatted as 'Firstname Lastname'" do
      expect(helper.format_email_to_name("katherine.johnson@nasa.org.uk")).to eq("Katherine Johnson")
    end
  end
end
