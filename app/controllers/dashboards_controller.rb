# frozen_string_literal: true

class DashboardsController < ApplicationController
  def index
    @registrations = WasteExemptionsEngine::Registration.all
  end
end
