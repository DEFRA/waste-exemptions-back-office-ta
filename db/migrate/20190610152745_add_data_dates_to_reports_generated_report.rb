class AddDataDatesToReportsGeneratedReport < ActiveRecord::Migration
  def change
    add_column :reports_generated_reports, :data_from_date, :date
    add_column :reports_generated_reports, :data_to_date, :date
  end
end
