# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Learn more: http://github.com/javan/whenever

set :output, "/home/rails/waste-exemptions-back-office/shared/log/whenever_cron.log"
set :job_template, "/bin/bash -l -c 'eval \"$(rbenv init -)\" && :job'"

# Only one of the AWS app servers has a role of "db"
# see https://gitlab.envage.co.uk/dst-south/waste-exemptions-deployment/blob/master/config/deploy.rb#L12
# so only creating cronjobs on that server, otherwise all jobs would be duplicated everyday!

# This is the daily EPR export job. When run this will create a CSV export of
# all records and put this into an AWS S3 bucket from which Epimorphics (the
# company that provides and maintains the EPR) will grab it
every :day, at: "1:05am", roles: [:db] do
  runner "DefraRuby::Exporters::RegistrationExportService.new.epr_export"
end
