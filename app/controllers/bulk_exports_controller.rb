# frozen_string_literal: true

class BulkExportsController < ApplicationController
  def show
    authorize! :read, Data::GeneratedReport

    @bulk_exports = BulkExportsPresenter.new
  end
end
