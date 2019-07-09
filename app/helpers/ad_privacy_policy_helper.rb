# frozen_string_literal: true

module AdPrivacyPolicyHelper
  def link_to_privacy_policy
    link_to(t(".privacy_policy"), page_path("privacy"), target: "_blank")
  end
end
