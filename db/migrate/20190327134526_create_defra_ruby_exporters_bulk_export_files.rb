class CreateDefraRubyExportersBulkExportFiles < ActiveRecord::Migration[4.2]
  def change
    create_table :defra_ruby_exporters_bulk_export_files do |t|
      t.string :file_name

      t.timestamps null: false
    end
  end
end
