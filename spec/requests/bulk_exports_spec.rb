# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Bulk Exports", type: :request do
  let(:user) { create(:user, :system) }

  before(:each) do
    sign_in(user)
  end

  describe "GET /data-exports" do
    before do
      create(:generated_report, created_at: Time.new(2019, 6, 1, 12, 0), data_from_date: Date.new(2019, 6, 1))
    end

    it "renders the correct template, the timestamp in an accessible format and responds with a 200 status code" do
      export_at_regex = /These files were created at 12:00pm on 1 June 2019\./m

      get bulk_exports_path

      expect(response).to render_template("bulk_exports/show")
      expect(response.body.scan(export_at_regex).count).to eq(1)
      expect(response.code).to eq("200")
    end
  end
end
