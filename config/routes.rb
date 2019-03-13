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

  # Registration management

  resources :registrations, only: :show, param: :reference
  resources :transient_registrations, only: :show, param: :reference, path: "/transient-registrations"

  # Engine

  mount WasteExemptionsEngine::Engine => "/"
end
