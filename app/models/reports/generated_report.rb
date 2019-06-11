# frozen_string_literal: true

require "defra_ruby/exporters"

module Reports
  class GeneratedReport < ActiveRecord::Base
    self.table_name = :reports_generated_reports
  end
end
