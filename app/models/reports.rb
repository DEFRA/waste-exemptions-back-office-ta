# frozen_string_literal: true

# We have put everything to do with reports into a `/reports` folder in the
# model, presenters, and services folder mainly just to keep things tidy.
# For presenters and services that was fine, but things broke in models.
#
# Hence this file, which magically seems to fix things! We don't understand why,
# and should we ever get 5 minutes and the inclination to do so we might try
# figure it out. But for now, we're just moving on 😁
require_relative "reports/monthly_bulk_serializer"

module Reports; end
