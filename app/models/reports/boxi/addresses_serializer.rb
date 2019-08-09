# frozen_string_literal: true

module Reports
  module Boxi
    class AddressesSerializer < BaseSerializer
      ATTRIBUTES = WasteExemptionsEngine::Address.column_names

      def file_name
        "addresses.csv"
      end

      def records_scope
        WasteExemptionsEngine::Address.all
      end

      def parse_description(description)
        description.gsub(/\r\n|\r|\n/, " ")
      end
    end
  end
end
