# frozen_string_literal: true

require "defra_ruby/exporters"

module Reports
  class GeneratedReport < ActiveRecord::Base
    self.table_name = :defra_ruby_exporters_bulk_export_files
  end
end
