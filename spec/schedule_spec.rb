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
  it "makes sure 'rake' statements exist" do
    schedule = Whenever::Test::Schedule.new(file: "config/schedule.rb")

    expect(schedule.jobs[:rake].count).to eq(1)
    expect(schedule.jobs[:rake].first[:task]).to eq("defra_ruby_exporters:epr")
  end

  it "takes the EPR execution time from the appropriate ENV variable" do
    schedule = Whenever::Test::Schedule.new(file: "config/schedule.rb")
    job_details = schedule.jobs[:rake].first { |h| h[:task] == "defra_ruby_exporters:epr" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq(ENV["EXPORT_SERVICE_EPR_EXPORT_TIME"])
  end

  it "takes the cron log output path from the appropriate ENV variable" do
    schedule = Whenever::Test::Schedule.new(file: "config/schedule.rb")

    expected_output_file = File.join(ENV["EXPORT_SERVICE_CRON_LOG_OUTPUT_PATH"], "whenever_cron.log")
    expect(schedule.sets[:output]).to eq(expected_output_file)
  end

  it "allows the `whenever` command to be called without raising an error" do
    Open3.popen3("bundle", "exec", "whenever") do |_, stdout, stderr, wait_thr|
      expect(stdout.read).to_not be_empty
      expect(stderr.read).to be_empty
      expect(wait_thr.value.success?).to eq(true)
    end
  end
end
