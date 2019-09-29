# frozen_string_literal: true

# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Learn more: http://github.com/javan/whenever

log_output_path = ENV["EXPORT_SERVICE_CRON_LOG_OUTPUT_PATH"] || "/srv/ruby/waste-exemptions-back-office/shared/log/"
set :output, File.join(log_output_path, "whenever_cron.log")
set :job_template, "/bin/bash -l -c 'eval \"$(rbenv init -)\" && :job'"

# Only one of the AWS app servers has a role of "db"
# see https://gitlab-dev.aws-int.defra.cloud/open/rails-deployment/blob/master/config/deploy.rb#L69
# so only creating cronjobs on that server, otherwise all jobs would be duplicated everyday!

# This is the daily EPR export job. When run this will create a CSV export of
# all records and put this into an AWS S3 bucket from which Epimorphics (the
# company that provides and maintains the EPR) will grab it
every :day, at: (ENV["EXPORT_SERVICE_EPR_EXPORT_TIME"] || "22:05"), roles: [:db] do
  rake "reports:export:epr"
end

# This is the registration exemptions exiry job which will collect all active
# registration exemptions that have an expire date in the past and will set their
# state to `expired`
bulk_time = (ENV["EXPIRE_REGISTRATION_EXEMPTION_RUN_TIME"] || "00:05")
every :day, at: bulk_time, roles: [:db] do
  rake "expire_registration:run"
end

# This is the transient registration cleanup job which will delete all records
# that are too old, as well as their associated addresses, exemptions and people
every :day, at: (ENV["CLEANUP_TRANSIENT_REGISTRATIONS_RUN_TIME"] || "00:35"), roles: [:db] do
  rake "cleanup:transient_registrations"
end

# This is the daily AD renewal letters export service.
# Will run once a day in the early morning hours and generate a PDF file containing
# all AD renewal letters expiring in X days.
every :day, at: (ENV["EXPORT_SERVICE_AD_RENEWAL_LETTERS_TIME"] || "00:45"), roles: [:db] do
  rake "letters:export:ad_renewals"
end

# This will run daily and update EA areas for addresses with x and y but without Area.
every :day, at: (ENV["AREA_LOOKUP"] || "01:05"), roles: [:db] do
  rake "lookups:update:missing_area"
end

# This will run daily and update easting and northing info for addresses using os places
every :day, at: (ENV["EASTING_AND_NORTHING_LOOKUP"] || "23:05"), roles: [:db] do
  rake "lookups:update:missing_easting_and_northing"
end

# This is the daily bulk export job. When run this will create batched CSV
# exports of all records and put these files into an AWS S3 bucket.
bulk_time = (ENV["EXPORT_SERVICE_BULK_EXPORT_TIME"] || "02:05")
every :day, at: bulk_time, roles: [:db] do
  rake "reports:export:bulk"
end

# This is the daily first renewal reminder mail service.
# Will run once a day in the early morning hours and send email reminders about
# registrations that will expire in X time.
every :day, at: (ENV["FIRST_RENEWAL_EMAIL_REMINDER_DAILY_RUN_TIME"] || "02:05"), roles: [:db] do
  rake "email:renew_reminder:first:send"
end

# This is the daily boxi export generation service.
# Will run once a day in the early morning hours and generate a zip file containing
# data required for boxi.
every :day, at: (ENV["EXPORT_SERVICE_BOXI_EXPORT_TIME"] || "03:05"), roles: [:db] do
  rake "reports:export:boxi"
end

# This is the daily second renewal reminder mail service.
# Will run once a day in the early morning hours and send email reminders about
# registrations that will expire in X time.
every :day, at: (ENV["SECOND_RENEWAL_EMAIL_REMINDER_DAILY_RUN_TIME"] || "04:05"), roles: [:db] do
  rake "email:renew_reminder:second:send"
end
