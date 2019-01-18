# frozen_string_literal: true

class DashboardsController < ApplicationController
  def index
    @registrations = matching_registrations(params[:page])
  end

  private

  def matching_registrations(page)
    SearchService.new.search(page)
  end
end
