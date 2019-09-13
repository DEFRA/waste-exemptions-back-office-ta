# frozen_string_literal: true

module Data
  module Boxi
    class PeopleSerializer < BaseSerializer
      ATTRIBUTES = WasteExemptionsEngine::Person.column_names

      def file_name
        "people.csv"
      end

      def records_scope
        WasteExemptionsEngine::Person.all
      end
    end
  end
end
