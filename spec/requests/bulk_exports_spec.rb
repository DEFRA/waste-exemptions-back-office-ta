# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Bulk Exports", type: :request do
  before(:context) do
    DefraRuby::Exporters::BulkExportFile.create(file_name: "waste_exemptions_bulk_export_20190201-20190228.csv")
    DefraRuby::Exporters::BulkExportFile.create(file_name: "waste_exemptions_bulk_export_20190301-20190331.csv")
    DefraRuby::Exporters::BulkExportFile.create(file_name: "waste_exemptions_bulk_export_20190401-20190430.csv")
  end

  let(:user) { create(:user, :system) }
  before(:each) do
    sign_in(user)
  end

  describe "GET /data-exports" do
    let(:num_files) { DefraRuby::Exporters::BulkExportFile.count }

    it "makes calls to S3 to get the links for each file" do
      expect(DefraRuby::Exporters::RegistrationExportService)
        .to receive(:presigned_url)
        .exactly(num_files)
        .times
      get bulk_exports_path
    end

    it "renders the correct template" do
      get bulk_exports_path
      expect(response).to render_template("bulk_exports/show")
    end

    it "renders a link for each file" do
      get bulk_exports_path
      file_name_regex = /waste_exemptions_bulk_export_\d{8}-\d{8}\.csv/m
      # The file name shows up twice in the presigned URL
      expect(response.body.scan(file_name_regex).count).to eq(num_files * 2)
    end

    it "responds with a 200 status code" do
      get bulk_exports_path
      expect(response.code).to eq("200")
    end
  end
end
