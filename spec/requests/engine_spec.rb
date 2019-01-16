# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Waste Exemptions Engine", type: :request do
  describe "/pages/version" do
    it "returns a 200 response" do
      get "/pages/version"
      expect(response).to have_http_status(200)
    end
  end
end
