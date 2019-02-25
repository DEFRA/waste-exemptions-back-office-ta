# frozen_string_literal: true

class DashboardsController < ApplicationController
  def index
    @term = params[:term]
    @results = matching_results(params[:page])
  end

  private

  def matching_results(page)
    SearchService.new.search(@term, page)
  end
end
