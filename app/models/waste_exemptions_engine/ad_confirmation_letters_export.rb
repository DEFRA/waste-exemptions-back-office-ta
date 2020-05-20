# frozen_string_literal: true

module WasteExemptionsEngine
  class AdConfirmationLettersExport < ActiveRecord::Base
    self.table_name = "ad_confirmation_letters_exports"

    validates :created_on, uniqueness: true

    enum status: { succeded: 0, failed: 1, deleted: 2 }

    scope :not_deleted, -> { where.not(status: 2) }

    def export!
      AdConfirmationLettersExportService.run(self)
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
