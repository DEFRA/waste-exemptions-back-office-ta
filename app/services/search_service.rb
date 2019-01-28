# frozen_string_literal: true

class SearchService
  def initialize; end

  def search(term, page)
    WasteExemptionsEngine::Registration.search_term(term).page(page)
  end
end
