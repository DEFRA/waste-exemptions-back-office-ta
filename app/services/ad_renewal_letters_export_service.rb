# frozen_string_literal: true

require_relative "concerns/can_load_file_to_aws"

class AdRenewalLettersExportService < ::WasteExemptionsEngine::BaseService
  include CanLoadFileToAws

  def run
    File.open(file_path, "w:ASCII-8BIT") do |file|
      file.write(RenewalLettersBulkPdfService.run(ad_expiring_registrations))
    end

    load_file_to_aws_bucket

    record_content_created
  rescue StandardError => e
    Airbrake.notify e, file_name: file_name
    Rails.logger.error "Generate AD renewal letters export error for #{file_name}:\n#{e}"
  ensure
    File.unlink(file_path) if File.exist?(file_name)
  end

  private

  def file_path
    Rails.root.join("tmp/#{file_name}")
  end

  def file_name
    date = Date.today.to_formatted_s(:plain_year_month_day)

    "ad_renewal_letters_#{date}.pdf"
  end

  def ad_expiring_registrations
    WasteExemptionsEngine::Registration
      .where(contact_email: "waste-exemptions@environment-agency.gov.uk")
      .where(
        id: WasteExemptionsEngine::RegistrationExemption
              .all_active_exemptions
              .where(expires_on: ad_letters_expires_on)
              .select(:registration_id)
      )
  end

  def bucket_name
    WasteExemptionsBackOffice::Application.config.letters_export_bucket_name
  end

  def ad_letters_expires_on
    WasteExemptionsBackOffice::Application.config.ad_letters_exports_expires_in.days.from_now.to_date
  end

  def record_content_created
    WasteExemptionsEngine::AdRenewalLettersExport.create!(
      expires_on: ad_letters_expires_on,
      number_of_letters: ad_expiring_registrations.count,
      file_name: file_name
    )
  end
end
