# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
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
  resources :new_registrations, only: :show, param: :reference, path: "/new-registrations"

  # Edit registrations
  resources :edit_forms,
            module: "waste_exemptions_engine",
            only: %i[new
                     create],
            path: "edit",
            path_names: { new: "/:token" } do
              get "location/:token",
                  to: "edit_forms#edit_location",
                  as: "location",
                  on: :collection

              get "applicant_name/:token",
                  to: "edit_forms#edit_applicant_name",
                  as: "applicant_name",
                  on: :collection

              get "applicant_phone/:token",
                  to: "edit_forms#edit_applicant_phone",
                  as: "applicant_phone",
                  on: :collection

              get "applicant_email/:token",
                  to: "edit_forms#edit_applicant_email",
                  as: "applicant_email",
                  on: :collection

              get "main_people/:token",
                  to: "edit_forms#edit_main_people",
                  as: "main_people",
                  on: :collection

              get "registration_number/:token",
                  to: "edit_forms#edit_registration_number",
                  as: "registration_number",
                  on: :collection

              get "operator_name/:token",
                  to: "edit_forms#edit_operator_name",
                  as: "operator_name",
                  on: :collection

              get "operator_postcode/:token",
                  to: "edit_forms#edit_operator_postcode",
                  as: "operator_postcode",
                  on: :collection

              get "contact_name/:token",
                  to: "edit_forms#edit_contact_name",
                  as: "contact_name",
                  on: :collection

              get "contact_phone/:token",
                  to: "edit_forms#edit_contact_phone",
                  as: "contact_phone",
                  on: :collection

              get "contact_email/:token",
                  to: "edit_forms#edit_contact_email",
                  as: "contact_email",
                  on: :collection

              get "contact_postcode/:token",
                  to: "edit_forms#edit_contact_postcode",
                  as: "contact_postcode",
                  on: :collection

              get "on_a_farm/:token",
                  to: "edit_forms#edit_on_a_farm",
                  as: "on_a_farm",
                  on: :collection

              get "is_a_farmer/:token",
                  to: "edit_forms#edit_is_a_farmer",
                  as: "is_a_farmer",
                  on: :collection

              get "site_grid_reference/:token",
                  to: "edit_forms#edit_site_grid_reference",
                  as: "site_grid_reference",
                  on: :collection
            end

  resources :edit_complete_forms,
            module: "waste_exemptions_engine",
            only: %i[new create],
            path: "edit-complete",
            path_names: { new: "/:token" }

  # Deregister Registrations

  get "/registrations/deregister/:id", to: "deregister_registrations#new", as: :deregister_registrations_form
  post "/registrations/deregister/:id", to: "deregister_registrations#update", as: :deregister_registrations

  # Deregister Exemptions

  get "/registration-exemptions/deregister/:id", to: "deregister_exemptions#new", as: :deregister_exemptions_form
  post "/registration-exemptions/deregister/:id", to: "deregister_exemptions#update", as: :deregister_exemptions

  # Engine

  mount WasteExemptionsEngine::Engine => "/"
end
# rubocop:enable Metrics/BlockLength
