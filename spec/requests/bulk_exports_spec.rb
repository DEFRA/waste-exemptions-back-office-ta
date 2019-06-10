# frozen_string_literal: true

require "rails_helper"
require "defra_ruby/exporters"

RSpec.describe "Bulk Exports", type: :request do
  let(:user) { create(:user, :system) }

  before(:each) do
    sign_in(user)
  end

  describe "GET /data-exports" do
    before do
      create(:generated_report, created_at: Time.new(2019, 6, 1, 12, 0))
    end

    it "renders the correct template" do
      get bulk_exports_path
      expect(response).to render_template("bulk_exports/show")
    end

    it "renders the timestamp in an accessible format" do
      export_at_regex = /These files were created at 12:00pm on 1 June 2019\./m

      get bulk_exports_path

      expect(response.body.scan(export_at_regex).count).to eq(1)
    end

    it "responds with a 200 status code" do
      get bulk_exports_path

      expect(response.code).to eq("200")
    end
  end
end
