# frozen_string_literal: true

module Reports
  module Boxi
    class RegistrationExemptionsSerializer < BaseSerializer
      ATTRIBUTES = WasteExemptionsEngine::RegistrationExemption.column_names

      def file_name
        "registration_exemptions.csv"
      end

      def records_scope
        WasteExemptionsEngine::RegistrationExemption.all
      end
    end
  end
end
