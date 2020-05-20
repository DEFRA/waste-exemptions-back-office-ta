# frozen_string_literal: true

class AdConfirmationLettersExportCleanerService < ::WasteExemptionsEngine::BaseService
  def run(older_than)
    WasteExemptionsEngine::AdConfirmationLettersExport
      .not_deleted
      .where("created_at < ?", older_than)
      .map(&:deleted!)
  rescue StandardError => e
    Airbrake.notify e, older_than: older_than
    Rails.logger.error "Failed to delete AdConfirmationLettersExport older_than #{older_than}:\n#{e}"
  end
end
