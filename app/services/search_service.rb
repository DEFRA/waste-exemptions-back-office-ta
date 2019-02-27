# frozen_string_literal: true

class SearchService
  def initialize; end

  def search(term, model, page)
    return Kaminari.paginate_array([]).page(page) if term.blank?

    if model == :transient_registrations
      WasteExemptionsEngine::TransientRegistration.search_registration_and_relations(term).page(page)
    else
      WasteExemptionsEngine::Registration.search_registration_and_relations(term).page(page)
    end
  end
end
