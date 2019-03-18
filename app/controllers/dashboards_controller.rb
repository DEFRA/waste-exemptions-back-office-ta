# frozen_string_literal: true

class DashboardsController < ApplicationController
  helper ActionLinksHelper

  def index
    @term = params[:term]
    @filter = params[:filter].to_sym if params[:filter].present?
    @results = matching_results(params[:page])
  end

  private

  def matching_results(page)
    SearchService.new.search(@term, @filter, page)
  end
end
