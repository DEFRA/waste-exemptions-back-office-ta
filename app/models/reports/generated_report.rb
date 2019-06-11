# frozen_string_literal: true

module Reports
  class GeneratedReport < ActiveRecord::Base
    self.table_name = :reports_generated_reports
  end
end
