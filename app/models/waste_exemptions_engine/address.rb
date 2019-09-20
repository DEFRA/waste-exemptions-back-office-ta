# frozen_string_literal: true

require WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "address")

module WasteExemptionsEngine
  class Address
    include CanBeSearchedLikeAddress

    scope :with_easting_and_northing, -> { where.not(x: nil, y: nil) }
    scope :missing_ea_area, -> { where(area: [nil, ""]) }
  end
end
