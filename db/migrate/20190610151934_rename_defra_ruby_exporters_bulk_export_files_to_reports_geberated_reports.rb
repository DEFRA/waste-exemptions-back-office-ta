class RenameDefraRubyExportersBulkExportFilesToReportsGeberatedReports < ActiveRecord::Migration[4.2]
  def self.up
    rename_table :defra_ruby_exporters_bulk_export_files, :reports_generated_reports
  end

  def self.down
    rename_table :reports_generated_reports, :defra_ruby_exporters_bulk_export_files
  end
end
