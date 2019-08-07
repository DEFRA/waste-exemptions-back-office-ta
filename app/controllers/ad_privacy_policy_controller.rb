# frozen_string_literal: true

class AdPrivacyPolicyController < ApplicationController
  before_action :set_registration

  def show; end

  private

  def set_registration
    @registration = WasteExemptionsEngine::Registration.find_by(reference: params[:renew_registration])
  end
end
