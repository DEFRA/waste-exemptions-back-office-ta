# frozen_string_literal: true

module DefraRuby
  module Exporters
    class BulkExportFile < ActiveRecord::Base
      self.table_name = :defra_ruby_exporters_bulk_export_files
    end
  end
end
