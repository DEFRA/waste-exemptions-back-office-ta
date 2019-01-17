# frozen_string_literal: true

Rails.application.routes.draw do
  mount WasteExemptionsEngine::Engine => "/"

  root "dashboards#index"

  devise_for :users,
             controllers: { sessions: "sessions" },
             path: "/bo/users",
             path_names: { sign_in: "sign_in", sign_out: "sign_out" }
end
