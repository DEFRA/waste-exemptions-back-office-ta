# frozen_string_literal: true

class AdRenewalLettersExportsController < ApplicationController
  def index
    authorize! :read, WasteExemptionsEngine::AdRenewalLettersExport

    @ad_renewal_letters_exports = WasteExemptionsEngine::AdRenewalLettersExport.all
  end

  def update
    @ad_renewal_letters_exports = WasteExemptionsEngine::AdRenewalLettersExport.find(params[:id])

    @ad_renewal_letters_exports.update_attributes(ad_renewal_letters_exports_attributes)

    redirect_to ad_renewal_letters_exports_path
  end

  def ad_renewal_letters_exports_attributes
    params.require(:ad_renewal_letters_export).permit(:printed_on, :printed_by)
  end
end
