# frozen_string_literal: true

class AdRenewalLettersExportsController < ApplicationController
  def index
    authorize! :read, WasteExemptionsEngine::AdRenewalLettersExport

    @ad_renewal_letters_exports_presenters = ad_renewal_letters_exports_presenters
  end

  def update
    ad_renewal_letters_export = WasteExemptionsEngine::AdRenewalLettersExport.find(params[:id])

    ad_renewal_letters_export.update(ad_renewal_letters_export_attributes)

    redirect_to ad_renewal_letters_exports_path
  end

  private

  def ad_renewal_letters_export_attributes
    params.require(:ad_renewal_letters_export).permit(:printed_on, :printed_by)
  end

  def ad_renewal_letters_exports_presenters
    WasteExemptionsEngine::AdRenewalLettersExport.not_deleted.map do |ad_renewal_letters_export|
      AdRenewalLettersExportPresenter.new(ad_renewal_letters_export)
    end
  end
end
