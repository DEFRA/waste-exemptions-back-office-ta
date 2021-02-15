# frozen_string_literal: true

require_relative "concerns/can_load_file_to_aws"

class AdConfirmationLettersExportService < ::WasteExemptionsEngine::BaseService
  include CanLoadFileToAws

  def run(ad_confirmation_letters_export)
    @ad_confirmation_letters_export = ad_confirmation_letters_export

    if ad_registrations.any?
      File.open(file_path, "w:ASCII-8BIT") do |file|
        file.write(ConfirmationLettersBulkPdfService.run(ad_registrations))
      end

      load_file_to_aws_bucket
    end

    record_content_created
  rescue StandardError => e
    Airbrake.notify e, file_name: file_name
    Rails.logger.error "Generate AD confirmation letters export error for #{file_name}:\n#{e}"

    record_content_errored
  ensure
    File.unlink(file_path) if File.exist?(file_path)
  end

  private

  def file_path
    @_file_path ||= Rails.root.join("tmp/#{file_name}")
  end

  def file_name
    @_file_name ||= lambda do
      date = @ad_confirmation_letters_export.created_on.to_formatted_s(:plain_year_month_day)

      "ad_confirmation_letters_#{date}.pdf"
    end.call
  end

  def ad_registrations
    @_ad_registrations ||= lambda do
      from = @ad_confirmation_letters_export.created_on.beginning_of_day
      to = @ad_confirmation_letters_export.created_on.end_of_day

      WasteExemptionsEngine::Registration
        .order(:reference)
        .where(contact_email: WasteExemptionsEngine.configuration.assisted_digital_email)
        .where(
          id: WasteExemptionsEngine::RegistrationExemption
                .all_active_exemptions
                .select(:registration_id)
        )
        .where(created_at: from..to)
    end.call
  end

  def bucket_name
    WasteExemptionsBackOffice::Application.config.letters_export_bucket_name
  end

  def record_content_created
    @ad_confirmation_letters_export.number_of_letters = ad_registrations.count
    @ad_confirmation_letters_export.file_name = file_name

    @ad_confirmation_letters_export.save!
    @ad_confirmation_letters_export.succeded!
  end

  def record_content_errored
    @ad_confirmation_letters_export.failed!
  end
end
