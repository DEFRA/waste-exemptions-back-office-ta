# frozen_string_literal: true

module Reports
  module Boxi
    class RegistrationsSerializer < BaseSerializer
      ATTRIBUTES = WasteExemptionsEngine::Registration.column_names

      def file_name
        "registrations.csv"
      end

      def records_scope
        WasteExemptionsEngine::Registration.all
      end
    end
  end
end
