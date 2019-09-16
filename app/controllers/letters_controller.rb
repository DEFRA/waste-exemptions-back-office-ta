# frozen_string_literal: true

class LettersController < ApplicationController
  def index
    authorize! :read, WasteExemptionsEngine::AdRenewalLettersExport
  end
end
