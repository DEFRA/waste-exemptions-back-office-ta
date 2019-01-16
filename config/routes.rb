# frozen_string_literal: true

Rails.application.routes.draw do
  mount WasteExemptionsEngine::Engine => "/"

  root "dashboards#index"
end
