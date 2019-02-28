# frozen_string_literal: true

module WasteExemptionsEngine
  module CanBeSearchedLikeRegistration
    extend ActiveSupport::Concern

    included do
      scope :search_registration_and_relations, lambda { |term|
        where(id: search_registration(term).ids +
                  search_for_site_address_postcode(term).ids +
                  search_for_person_name(term).ids)
      }

      scope :search_registration, lambda { |term|
        where(
          "UPPER(applicant_email) = ?\
           OR UPPER(CONCAT(applicant_first_name, ' ', applicant_last_name)) LIKE ?\
           OR UPPER(contact_email) = ?\
           OR UPPER(CONCAT(contact_first_name, ' ', contact_last_name)) LIKE ?\
           OR UPPER(operator_name) LIKE ?\
           OR UPPER(reference) = ?",
          term&.upcase,        # applicant_email
          "%#{term&.upcase}%", # applicant names
          term&.upcase,        # contact_email
          "%#{term&.upcase}%", # contact names
          "%#{term&.upcase}%", # operator_name
          term&.upcase         # reference
        )
      }
    end
  end
end
