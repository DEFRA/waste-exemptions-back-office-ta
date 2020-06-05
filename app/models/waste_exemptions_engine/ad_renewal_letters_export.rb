# frozen_string_literal: true

require WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "application_record")

module WasteExemptionsEngine
  class AdRenewalLettersExport < ::WasteExemptionsEngine::ApplicationRecord
    self.table_name = "ad_renewal_letters_exports"

    validates :expires_on, uniqueness: true

    enum status: { succeded: 0, failed: 1, deleted: 2 }

    scope :not_deleted, -> { where.not(status: 2) }

    def export!
      AdRenewalLettersExportService.run(self)
    end

    def printed?
      printed_on.present? && printed_by.present?
    end

    def presigned_aws_url
      bucket.presigned_url(file_name)
    end

    def deleted!
      bucket.delete(file_name)

      super
    end

    private

    def bucket
      @_bucket ||= DefraRuby::Aws.get_bucket(bucket_name)
    end

    def bucket_name
      WasteExemptionsBackOffice::Application.config.letters_export_bucket_name
    end
  end
end
