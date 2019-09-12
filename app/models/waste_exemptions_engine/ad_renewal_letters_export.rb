# frozen_string_literal: true

module WasteExemptionsEngine
  class AdRenewalLettersExport < ActiveRecord::Base
    self.table_name = "ad_renewal_letters_exports"

    validates :expires_on, uniqueness: true

    enum status: { succeded: 0, failed: 1 }

    def export!
      AdRenewalLettersExportService.run(self)
    end
  end
end
