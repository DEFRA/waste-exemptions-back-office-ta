# frozen_string_literal: true

module WasteExemptionsEngine
  class AdRenewalLettersExport < ActiveRecord::Base
    self.table_name = "ad_renewal_letters_exports"

    validates :expires_on, uniqueness: true

    enum status: { succeded: 0, failed: 1 }

    def export!
      AdRenewalLettersExportService.run(self)
    end

    def printed?
      printed_on.presence && printed_by.presence
    end

    def presigned_aws_url
      bucket.presigned_url(file_name)
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
