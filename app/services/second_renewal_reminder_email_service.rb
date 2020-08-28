# frozen_string_literal: true

require "notifications/client"

class SecondRenewalReminderEmailService < RenewalReminderEmailService
  private

  def template
    "80585fc6-9c65-4909-8cb4-6888fa4427c8"
  end
end
