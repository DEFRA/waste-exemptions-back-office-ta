# frozen_string_literal: true

require_relative "concerns/can_load_file_to_aws"

class AdRenewalLettersExportService < ::WasteExemptionsEngine::BaseService
  include CanLoadFileToAws

  def run(ad_renewal_letters_export)
    @ad_renewal_letters_export = ad_renewal_letters_export

    if ad_expiring_registrations.any?
      File.open(file_path, "w:ASCII-8BIT") do |file|
        file.write(RenewalLettersBulkPdfService.run(ad_expiring_registrations))
      end

      load_file_to_aws_bucket
    end

    record_content_created
  rescue StandardError => e
    Airbrake.notify e, file_name: file_name
    Rails.logger.error "Generate AD renewal letters export error for #{file_name}:\n#{e}"

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
      date = @ad_renewal_letters_export.expires_on.to_formatted_s(:plain_year_month_day)

      "ad_renewal_letters_#{date}.pdf"
    end.call
  end

  def ad_expiring_registrations
    @_ad_expiring_registrations ||= lambda do
      WasteExemptionsEngine::Registration
        .where(contact_email: "waste-exemptions@environment-agency.gov.uk")
        .where(
          id: WasteExemptionsEngine::RegistrationExemption
                .all_active_exemptions
                .where(expires_on: @ad_renewal_letters_export.expires_on)
                .select(:registration_id)
        )
    end.call
  end

  def bucket_name
    WasteExemptionsBackOffice::Application.config.letters_export_bucket_name
  end

  def record_content_created
    @ad_renewal_letters_export.number_of_letters = ad_expiring_registrations.count
    @ad_renewal_letters_export.file_name = file_name

    @ad_renewal_letters_export.save!
  end

  def record_content_errored
    @ad_renewal_letters_export.failed!
  end
end
