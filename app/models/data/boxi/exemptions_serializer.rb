# frozen_string_literal: true

module Data
  module Boxi
    class ExemptionsSerializer < BaseSerializer
      ATTRIBUTES = WasteExemptionsEngine::Exemption.column_names

      def file_name
        "exemptions.csv"
      end

      def records_scope
        WasteExemptionsEngine::Exemption.all
      end
    end
  end
end
