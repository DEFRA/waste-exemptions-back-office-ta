# frozen_string_literal: true

module BoxiExport
  class AddressesSerializer < BaseSerializer
    ATTRIBUTES = WasteExemptionsEngine::Address.column_names

    def file_name
      "addresses.csv"
    end

    def records_scope
      WasteExemptionsEngine::Address.all
    end
  end
end
