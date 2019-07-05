# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExpiredRegistrationsService do
  describe ".run" do
    it "sets the status of active registration exemptions that have an expiry date in the past to expired" do
      expired_registration_exemption = create(:registration_exemption, expires_on: 1.day.ago)

      expect { described_class.run }
        .to change { expired_registration_exemption.reload.state }
        .from("active")
        .to("expired")
    end

    it "does not change the state of expired registration that are not in an active status" do
      expired_registration_exemption = create(:registration_exemption, :ceased, expires_on: 1.day.ago)

      expect { described_class.run }
        .not_to change { expired_registration_exemption.reload.state }
    end
  end
end
