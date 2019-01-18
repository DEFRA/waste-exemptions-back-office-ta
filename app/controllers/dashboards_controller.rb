# frozen_string_literal: true

class DashboardsController < ApplicationController
  def index
    @registrations = matching_registrations
  end

  private

  def matching_registrations
    SearchService.new.search
  end
end
