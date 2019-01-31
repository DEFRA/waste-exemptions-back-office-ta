# frozen_string_literal: true

class SearchService
  def initialize; end

  def search(term, page)
    return Kaminari.paginate_array([]).page(page) if term.blank?

    WasteExemptionsEngine::Registration.search_registration_and_relations(term).page(page)
  end
end
