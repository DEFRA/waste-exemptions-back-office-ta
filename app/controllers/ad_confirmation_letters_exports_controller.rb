# frozen_string_literal: true

class AdConfirmationLettersExportsController < ApplicationController
  def index
    authorize! :read, WasteExemptionsEngine::AdConfirmationLettersExport

    @ad_confirmation_letters_exports_presenters = ad_confirmation_letters_exports_presenters
  end

  def update
    ad_confirmation_letters_export = WasteExemptionsEngine::AdConfirmationLettersExport.find(params[:id])

    ad_confirmation_letters_export.update(ad_confirmation_letters_export_attributes)

    redirect_to ad_confirmation_letters_exports_path
  end

  private

  def ad_confirmation_letters_export_attributes
    params.require(:ad_confirmation_letters_export).permit(:printed_on, :printed_by)
  end

  def ad_confirmation_letters_exports_presenters
    WasteExemptionsEngine::AdConfirmationLettersExport.not_deleted.map do |ad_confirmation_letters_export|
      AdConfirmationLettersExportPresenter.new(ad_confirmation_letters_export)
    end
  end
end
