# frozen_string_literal: true

require "rails_helper"
require "whenever/test"
require "open3"

# This allows us to ensure that the schedules we have declared in whenever's
# (https://github.com/javan/whenever) config/schedule.rb are valid.
# The hope is this saves us from only being able to confirm if something will
# work by actually running the deployment and seeing if it breaks (or not)
# See https://github.com/rafaelsales/whenever-test for more details

RSpec.describe "Whenever schedule", vcr: true do
  it "makes sure 'runner' statements exist" do
    schedule = Whenever::Test::Schedule.new(file: "config/schedule.rb")

    expect(schedule.jobs[:runner].count).to eq(1)

    # Making the instance_eval call appears to actually kick off the job and
    # therefore involves a hit on S3, hence we have mocked it using VCR
    export_matcher = Helpers::VCR.export_matcher(ENV["AWS_DAILY_EXPORT_BUCKET"])
    VCR.use_cassette("save_epr_export_to_s3", match_requests_on: [:method, export_matcher]) do
      # Executes the actual ruby statement to make sure all constants and
      # methods exist:
      schedule.jobs[:runner].each { |job| instance_eval job[:task] }
    end
  end

  it "takes the EPR execution time from the appropriate ENV variable" do
    schedule = Whenever::Test::Schedule.new(file: "config/schedule.rb")
    job_details = schedule.jobs[:runner].first do |h|
      h[:task] == "DefraRuby::Exporters::RegistrationExportService.new.epr_export"
    end

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq(ENV["EXPORT_SERVICE_EPR_EXPORT_TIME"])
  end

  it "allows the `whenever` command to be called without raising an error" do
    _, stdout, stderr, wait_thr = Open3.popen3("bundle", "exec", "whenever")
    expect(stdout.read).to_not be_empty
    expect(stderr.read).to be_empty
    expect(wait_thr.value.success?).to eq(true)
  end
end
