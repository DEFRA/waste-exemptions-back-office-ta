# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ResendConfirmationEmail", type: :request do
  let(:registration) { create(:registration) }

  describe "GET /resend-confirmation-email/:reference" do
    let(:request_path) { "/resend-confirmation-email/#{registration.reference}" }

    before { sign_in(user) if defined?(user) }

    context "when a data agent user is signed in" do
      let(:user) { create(:user, :data_agent) }

      it "redirects to permission page" do
        get request_path, params: {}, headers: { "HTTP_REFERER" => "/" }
        follow_redirect!

        expect(response).to render_template("pages/permission")
      end
    end

    context "when an admin agent user is signed in", disable_bullet: true do
      let(:user) { create(:user, :admin_agent) }

      around do |example|
        # Bullet can't make up its mind about whether or not we should eager-load
        # `registration_exemptions: :exemption` - if we have it, it tells us to
        # remove it, and if we don't have it, it tells us to add it.
        # In this case we're leaving it in and telling Bullet to pipe down.
        Bullet.unused_eager_loading_enable = false

        example.run

        Bullet.unused_eager_loading_enable = true
      end

      context "when the recipients are the same" do
        before do
          registration.update(applicant_email: registration.contact_email)
        end

        it "returns a success message" do
          VCR.use_cassette("first_confirmation_reminder_email") do
            success_message = I18n.t("resend_confirmation_email.messages.success.one",
                                     default_email: registration.contact_email)

            get request_path, params: {}, headers: { "HTTP_REFERER" => "/" }
            follow_redirect!

            expect(response.body).to include(success_message)
          end
        end

        context "when an error happens" do
          before do
            expect(WasteExemptionsEngine::ConfirmationEmailService).to receive(:run).and_raise(StandardError)
          end

          it "returns an error message" do
            error_message = I18n.t("resend_confirmation_email.messages.failure_details")

            get request_path, params: {}, headers: { "HTTP_REFERER" => "/" }
            follow_redirect!

            expect(response.body).to include(error_message)
          end
        end
      end

      context "when there is one valid recipient and one AD recipient" do
        before do
          registration.update(contact_email: "waste-exemptions@environment-agency.gov.uk")
        end

        it "returns a success message" do
          success_message = I18n.t("resend_confirmation_email.messages.success.one",
                                   default_email: registration.applicant_email)

          # Chose to stub this rather than have to deal with VCR and multiple requests
          expect(WasteExemptionsEngine::ConfirmationEmailService).to receive(:run).with(
            registration: registration,
            recipient: registration.applicant_email
          )
          expect(WasteExemptionsEngine::ConfirmationEmailService).to_not receive(:run).with(
            registration: registration,
            recipient: registration.contact_email
          )

          get request_path, params: {}, headers: { "HTTP_REFERER" => "/" }
          follow_redirect!

          expect(response.body).to include(success_message)
        end

        context "when an error happens" do
          before do
            expect(WasteExemptionsEngine::ConfirmationEmailService).to receive(:run).and_raise(StandardError)
          end

          it "returns an error message" do
            error_message = I18n.t("resend_confirmation_email.messages.failure_details")

            get request_path, params: {}, headers: { "HTTP_REFERER" => "/" }
            follow_redirect!

            expect(response.body).to include(error_message)
          end
        end
      end

      context "when there are multiple recipients" do
        it "returns a success message" do
          success_message = I18n.t("resend_confirmation_email.messages.success.other",
                                   applicant_email: registration.applicant_email,
                                   contact_email: registration.contact_email)

          # Chose to stub this rather than have to deal with VCR and multiple requests
          expect(WasteExemptionsEngine::ConfirmationEmailService).to receive(:run).with(
            registration: registration,
            recipient: registration.applicant_email
          )
          expect(WasteExemptionsEngine::ConfirmationEmailService).to receive(:run).with(
            registration: registration,
            recipient: registration.contact_email
          )

          get request_path, params: {}, headers: { "HTTP_REFERER" => "/" }
          follow_redirect!

          expect(response.body).to include(success_message)
        end

        context "when an error happens" do
          before do
            expect(WasteExemptionsEngine::ConfirmationEmailService).to receive(:run).and_raise(StandardError)
          end

          it "returns an error message" do
            error_message = I18n.t("resend_confirmation_email.messages.failure_details")

            get request_path, params: {}, headers: { "HTTP_REFERER" => "/" }
            follow_redirect!

            expect(response.body).to include(error_message)
          end
        end
      end

      context "when there are no recipients" do
        before do
          registration.update(applicant_email: "waste-exemptions@environment-agency.gov.uk",
                              contact_email: "waste-exemptions@environment-agency.gov.uk")
        end

        it "returns a success message" do
          expect(WasteExemptionsEngine::ConfirmationEmailService).to_not receive(:run)

          success_message = I18n.t("resend_confirmation_email.messages.success.zero")

          get request_path, params: {}, headers: { "HTTP_REFERER" => "/" }
          follow_redirect!

          expect(response.body).to include(success_message)
        end
      end
    end

    context "when a valid user is not signed in" do
      before { sign_out(create(:user)) }

      it "redirects to the sign-in page" do
        get request_path, params: {}, headers: { "HTTP_REFERER" => "/" }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
