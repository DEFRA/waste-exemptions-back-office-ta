# frozen_string_literal: true

Rails.application.routes.draw do
  mount WasteExemptionsEngine::Engine => "/"

  root "waste_exemptions_engine/start_forms#new"
end
