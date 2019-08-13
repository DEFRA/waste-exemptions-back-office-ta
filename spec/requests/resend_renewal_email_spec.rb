# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ResendRenewalEmail", type: :request do
  let(:registration) { create(:registration) }

  describe "GET /resend-renewal-email/:reference" do
    let(:request_path) { "/resend-renewal-email/#{registration.reference}" }

    before { sign_in(user) if defined?(user) }

    context "when a data agent user is signed in" do
      let(:user) { create(:user, :data_agent) }

      it "redirects to permission page" do
        get request_path, {}, "HTTP_REFERER" => "/"
        follow_redirect!

        expect(response).to render_template("pages/permission")
      end
    end

    context "when an admin agent user is signed in" do
      let(:user) { create(:user, :admin_agent) }

      it "return a 302 redirect code" do
        get request_path, {}, "HTTP_REFERER" => "/"

        expect(response.code).to eq("302")
      end

      it "return a success message" do
        success_message = I18n.t("resend_renewal_email.messages.success", email: registration.contact_email)

        get request_path, {}, "HTTP_REFERER" => "/"
        follow_redirect!

        expect(response.body).to include(success_message)
      end

      context "when an error happens", disable_bullet: true do
        before do
          expect(RenewalReminderMailer).to receive(:first_renew_with_magic_link_email).and_raise(StandardError)
        end

        around do |example|
          # We want bullet disable for eager loading.
          # We are not concerned about an unused eager loading when an error happens
          Bullet.unused_eager_loading_enable = false

          example.run

          Bullet.unused_eager_loading_enable = true
        end

        it "return a 302 redirect code" do
          get request_path, {}, "HTTP_REFERER" => "/"

          expect(response.code).to eq("302")
        end

        it "return an error message" do
          error_message = I18n.t("resend_renewal_email.messages.failure_details")

          get request_path, {}, "HTTP_REFERER" => "/"
          follow_redirect!

          expect(response.body).to include(error_message)
        end
      end
    end

    context "when a valid user is not signed in" do
      before { sign_out(create(:user)) }

      it "redirects to the sign-in page" do
        get request_path, {}, "HTTP_REFERER" => "/"

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
