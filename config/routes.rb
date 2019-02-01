# frozen_string_literal: true

Rails.application.routes.draw do
  root "dashboards#index"

  devise_for :users,
             controllers: { sessions: "sessions" },
             path: "/users",
             path_names: { sign_in: "sign_in", sign_out: "sign_out" }

  mount WasteExemptionsEngine::Engine => "/"
end
