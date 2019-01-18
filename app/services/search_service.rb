# frozen_string_literal: true

class SearchService
  def initialize; end

  def search
    WasteExemptionsEngine::Registration.all
  end
end
