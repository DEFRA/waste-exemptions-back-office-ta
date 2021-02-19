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

# This is the EPR export job. When run this will create a single CSV file of all
# active exemptions and put this into an AWS S3 bucket from which the company
# that provides and maintains the Electronis Public Register will grab it
every :day, at: (ENV["EXPORT_SERVICE_EPR_EXPORT_TIME"] || "22:05"), roles: [:db] do
  rake "reports:export:epr"
end

# This is the missing easting and northing job. When run it will update the
# easting and northing fields for all site addresses where they are currently
# nil, using os places to work out what they should be
every :day, at: (ENV["EASTING_AND_NORTHING_LOOKUP"] || "23:05"), roles: [:db] do
  rake "lookups:update:missing_easting_and_northing"
end

# This is the registration exemptions expiry job which will collect all active
# registration exemptions that have an expiry date in the past and will set
# their state to `expired`
every :day, at: (ENV["EXPIRE_REGISTRATION_EXEMPTION_RUN_TIME"] || "00:05"), roles: [:db] do
  rake "expire_registration:run"
end

# This is the transient registration cleanup job which will delete all records
# that are more than 30 days old, as well as associated records
every :day, at: (ENV["CLEANUP_TRANSIENT_REGISTRATIONS_RUN_TIME"] || "00:35"), roles: [:db] do
  rake "cleanup:transient_registrations"
end

# This is the Notify AD renewal letters job. When run it will send out Notify
# renewal letters for all AD registrations expiring in 35 days' time
every :day, at: (ENV["NOTIFY_AD_RENEWAL_LETTERS_TIME"] || "02:35"), roles: [:db] do
  rake "notify:letters:ad_renewals"
end

# This is the AD renewal letters export job. When run it will generate a single
# PDF containing renewal reminder letters for all AD registrations expirying
# in 35 days time
every :day, at: (ENV["EXPORT_SERVICE_AD_RENEWAL_LETTERS_TIME"] || "00:45"), roles: [:db] do
  rake "letters:export:ad_renewals"
end

# This is the AD confirmation letters export job. When run it will generate a single
# PDF containing confirmation letters for all AD registrations created today
every :day, at: (ENV["EXPORT_SERVICE_AD_CONFIRMATION_LETTERS_TIME"] || "22:35"), roles: [:db] do
  rake "letters:export:ad_confirmations"
end

# This is the area update job. When run it will update the area field for all
# site addresses where it is nil, as long as they have a populated x & y
# (easting and northing)
every :day, at: (ENV["AREA_LOOKUP"] || "01:05"), roles: [:db] do
  rake "lookups:update:missing_area"
end

# This is the bulk export job. When run this will create a series of CSV files
# containing details on all registered exemptions regardless of status. The
# files are batched by month, so there will be one for each month the service
# has been live
every :day, at: (ENV["EXPORT_SERVICE_BULK_EXPORT_TIME"] || "02:05"), roles: [:db] do
  rake "reports:export:bulk"
end

# This is the first renewal email reminder job. For each registration expiring
# in 30 days time, it will generate and send the first email reminder
every :day, at: (ENV["FIRST_RENEWAL_EMAIL_REMINDER_DAILY_RUN_TIME"] || "02:05"), roles: [:db] do
  rake "email:renew_reminder:first:send"
end

# This is the BOXI export job. When run this will generate a zip file of CSV's,
# each of which contains the data from the WEX database table e.g. registrations
# to registrations.csv, addresses to addresses.csv. This is then uploaded to AWS
# S3 from where it is grabbed by a process that imports it into the WEX BOXI
# universe
every :day, at: (ENV["EXPORT_SERVICE_BOXI_EXPORT_TIME"] || "03:05"), roles: [:db] do
  rake "reports:export:boxi"
end

# This is the second renewal email reminder job. For each registration expiring
# in 7 days time, it will generate and send the second email reminder
every :day, at: (ENV["SECOND_RENEWAL_EMAIL_REMINDER_DAILY_RUN_TIME"] || "04:05"), roles: [:db] do
  rake "email:renew_reminder:second:send"
end
