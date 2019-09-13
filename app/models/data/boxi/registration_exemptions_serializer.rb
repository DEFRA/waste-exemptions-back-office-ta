# frozen_string_literal: true

module Data
  module Boxi
    class RegistrationExemptionsSerializer < BaseSerializer
      ATTRIBUTES = WasteExemptionsEngine::RegistrationExemption.column_names

      def file_name
        "registration_exemptions.csv"
      end

      def records_scope
        WasteExemptionsEngine::RegistrationExemption.all
      end

      def parse_deregistration_message(message)
        message&.gsub(/\r\n|\r|\n/, " ")
      end
    end
  end
end
