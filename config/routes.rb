# frozen_string_literal: true

Rails.application.routes.draw do
  root "dashboards#index"

  # User management

  devise_for :users,
             controllers: { invitations: "user_invitations", sessions: "sessions" },
             path: "/users",
             path_names: { sign_in: "sign_in", sign_out: "sign_out" }

  get "/users", to: "users#index", as: :users

  get "/users/role/:id", to: "user_roles#edit", as: :user_role_form
  post "/users/role/:id", to: "user_roles#update", as: :user_role

  get "/users/activate/:id", to: "user_activations#activate_form", as: :activate_user_form
  get "/users/deactivate/:id", to: "user_activations#deactivate_form", as: :deactivate_user_form
  post "/users/activate/:id", to: "user_activations#activate", as: :activate_user
  post "/users/deactivate/:id", to: "user_activations#deactivate", as: :deactivate_user

  # Confirmation Letter

  get "/confirmation-letter/:id", to: "confirmation_letter#show", as: :confirmation_letter

  # Bulk Exports

  get "/data-exports", to: "bulk_exports#show", as: :bulk_exports

  # Registration management

  resources :registrations, only: :show, param: :reference
  resources :new_registrations, only: :show, path: "/new-registrations"

  # Deregister Registrations

  get "/registrations/deregister/:id", to: "deregister_registrations#new", as: :deregister_registrations_form
  post "/registrations/deregister/:id", to: "deregister_registrations#update", as: :deregister_registrations

  # Privacy policy

  get "/ad-privacy-policy", to: "ad_privacy_policy#show", as: :ad_privacy_policy

  # Deregister Exemptions

  get "/registration-exemptions/deregister/:id", to: "deregister_exemptions#new", as: :deregister_exemptions_form
  post "/registration-exemptions/deregister/:id", to: "deregister_exemptions#update", as: :deregister_exemptions

  # Engine

  mount WasteExemptionsEngine::Engine => "/"
end
