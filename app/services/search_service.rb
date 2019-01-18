# frozen_string_literal: true

class SearchService
  def initialize; end

  def search(page)
    WasteExemptionsEngine::Registration.all.page(page)
  end
end
