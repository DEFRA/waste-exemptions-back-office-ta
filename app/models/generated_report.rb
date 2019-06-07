# frozen_string_literal: true

require "defra_ruby/exporters"

class GeneratedReport < ActiveRecord::Base
  self.table_name = :defra_ruby_exporters_bulk_export_files
end
