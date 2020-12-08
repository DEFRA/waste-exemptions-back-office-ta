# frozen_string_literal: true

namespace :one_off do
  desc "Fix areas for exemptions on same site (see RUBY-1234)"
  # Run as rake one_off:area_fix["WEX1234 WEX5678 WEXetc"]
  task :area_fix, [:references] => [:environment] do |_task, args|
    references = args[:references].split(" ")

    references.each do |reference|
      print "Updating area for #{reference}..."
      reg = WasteExemptionsEngine::Registration.where(reference: reference).first
      puts reg.site_address.update(area: "West Midlands")
    end
  end
end
