# frozen_string_literal: true

module CanBeSearchedLikePerson
  extend ActiveSupport::Concern

  included do
    scope :search_for_name, lambda { |term|
      where("UPPER(CONCAT(first_name, ' ', last_name)) LIKE ?", "%#{term&.upcase}%")
    }
  end
end
