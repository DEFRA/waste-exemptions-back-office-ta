# frozen_string_literal: true

class BulkExportsController < ApplicationController
  def show
    authorize! :read, DefraRuby::Exporters::RegistrationBulkExportReport

    @bulk_exports = BulkExportsPresenter.new
  end
end
