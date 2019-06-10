# frozen_string_literal: true

require "defra_ruby/exporters"

class BulkExportsPresenter

  def links
    @_links ||= generated_reports_scope.map do |generated_report|
      build_link_data(generated_report)
    end
  end

  def exported_at_message
    return I18n.t("bulk_exports.show.not_yet_exported") if export_executed_at.blank?

    export_executed_at_string = export_executed_at.to_formatted_s(:time_on_day_month_year)
    I18n.t("bulk_exports.show.exported_at", export_executed_at: export_executed_at_string)
  end

  private

  def build_link_data(generated_report)
    {
      url: bucket.presigned_url(generated_report.file_name),
      text: generated_report.starts_from.to_formatted_s(:month_year)
    }
  end

  def export_executed_at
    @_export_executed_at ||= generated_reports_scope.first&.created_at
  end

  def generated_reports_scope
    Reports::GeneratedReport.order(:created_at)
  end

  def bucket
    DefraRuby::Aws.get_bucket(bucket_name)
  end

  def bucket_name
    WasteExemptionsBackOffice::Application.config.bulk_reports_bucket_name
  end
end
