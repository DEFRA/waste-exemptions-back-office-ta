# frozen_string_literal: true

class BulkExportsController < ApplicationController
  def show
    authorize! :read, DefraRuby::Exporters::RegistrationBulkExportReport

    define_links
    define_exported_at_message
  end

  private

  def define_exported_at_message
    export_executed_at = DefraRuby::Exporters::BulkExportFile.first&.created_at
    msg = export_executed_at.nil? ? t(".not_yet_executed") : t(".exported_at", export_executed_at: export_executed_at)
    @exported_at_message = msg
  end

  def define_links
    @bulk_export_links = DefraRuby::Exporters::BulkExportFile.all.map do |bulk_export_file|
      construct_link_data(bulk_export_file.file_name)
    end

    @bulk_export_links.sort_by! { |h| h[:start_date] }.reverse!
  end

  def construct_link_data(file_name)
    date_range_description = file_name.split("_").last.sub(".csv", "")
    date_range = DefraRuby::Exporters::Helpers::DateRange.parse_date_range_description(date_range_description)
    {
      start_date: date_range.first,
      url: DefraRuby::Exporters::RegistrationExportService.presigned_url(:bulk, file_name),
      text: link_text(date_range)
    }
  end

  def link_text(date_range)
    start_month = date_range.first.strftime("%B %Y")
    end_month = date_range.last.strftime("%B %Y")
    start_month == end_month ? start_month : "#{start_month} through #{end_month}"
  end
end
