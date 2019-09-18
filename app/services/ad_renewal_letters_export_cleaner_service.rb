# frozen_string_literal: true

class AdRenewalLettersExportCleanerService < ::WasteExemptionsEngine::BaseService
  def run(older_than)
    WasteExemptionsEngine::AdRenewalLettersExport
      .not_deleted
      .where("created_at < ?", older_than)
      .map(&:deleted!)
  rescue StandardError => e
    Airbrake.notify e, older_than: older_than
    Rails.logger.error "Failed to delete AdRenewalLettersExport older_than #{older_than}:\n#{e}"
  end
end
