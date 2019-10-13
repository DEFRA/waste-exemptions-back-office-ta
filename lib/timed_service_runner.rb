# frozen_string_literal: true

# Use in conjunction with long running tasks which you need to be throttled to
# only run for a certain length of time.
#
# For example rake task lookups:update:missing_area first finds then updates
# all site addresses missing an area. To ensure this does not run for too long
# we use +TimedServiceRunner+ to limit how long it runs for.
#
#     run_for = 60 # minutes
#     job_scope = WasteExemptionsEngine::Address.site.missing_area.with_easting_and_northing
#     service_to_run = UpdateAreaService
#
#     TimedServiceRunner.run(
#       scope: job_scope,
#       run_for: run_for,
#       service: service_to_run
#     )
#
class TimedServiceRunner
  def self.run(scope:, run_for:, service:)
    run_until = run_for.minutes.from_now

    scope.find_each do |address|
      break if Time.now > run_until

      begin
        service.run(address: address)
        address.save!
      rescue StandardError => e
        Airbrake.notify(e, address_id: address.id) if defined? Airbrake
        Rails.logger.error "#{service.name.demodulize} failed:\n #{e}"
      end
    end
  end
end
