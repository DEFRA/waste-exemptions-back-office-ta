# frozen_string_literal: true

require WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "address")

module WasteExemptionsEngine
  class Address
    include CanBeSearchedLikeAddress

    # S9 4WF with an optional space in the middle
    NCCC_POSTCODE_REGEX = "S9 ?4WF"

    scope :nccc, -> { where("postcode ~* '#{NCCC_POSTCODE_REGEX}'") }
    scope :not_nccc, -> { where.not(id: nccc) }
  end
end
